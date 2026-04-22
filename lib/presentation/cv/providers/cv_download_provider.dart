import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdfx/pdfx.dart';

import '../../../core/services/ad_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../domain/entities/cv_data.dart';
import '../../../domain/entities/completed_cv.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../drafts/providers/draft_provider.dart';
import '../../drafts/providers/completed_cv_provider.dart';
import '../../templates/providers/template_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';

enum DownloadStatus { idle, loading, generating, success, error }

class CVDownloadState {
  final DownloadStatus status;
  final String? errorMessage;

  const CVDownloadState({this.status = DownloadStatus.idle, this.errorMessage});

  CVDownloadState copyWith({DownloadStatus? status, String? errorMessage}) {
    return CVDownloadState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class CVDownloadNotifier extends Notifier<CVDownloadState> {
  final Map<String, String> _localCache = {};

  @override
  CVDownloadState build() {
    return const CVDownloadState();
  }

  String _buildCacheKey(
    String styleId,
    String locale, {
    bool usePhoto = false,
  }) {
    final creationState = ref.read(cvCreationProvider);
    final photoUrl = ref
        .read(profileControllerProvider)
        .currentProfile
        .photoUrl;

    final payload = {
      'cvData': {
        ...creationState.userProfile!.toJson(),
        'summary': creationState.summary,
        'jobTitle': creationState.jobInput?.jobTitle,
        'jobDescription': creationState.jobInput?.jobDescription,
        'styleId': styleId,
        'jobInput': creationState.jobInput?.toJson(),
      },
      'templateId': styleId,
      'locale': locale,
      'usePhoto': usePhoto,
      if (usePhoto && photoUrl != null) 'photoUrl': photoUrl,
    };
    final raw = jsonEncode(payload);
    return md5.convert(utf8.encode(raw)).toString();
  }

  Future<void> attemptDownload({
    required BuildContext context,
    required String styleId,
    String? locale,
    bool usePhoto = false,
    VoidCallback? onSuccess,
  }) async {
    final effectiveLocale =
        locale ?? ref.read(localeNotifierProvider).languageCode;
    final cacheKey = _buildCacheKey(
      styleId,
      effectiveLocale,
      usePhoto: usePhoto,
    );

    if (_localCache.containsKey(cacheKey)) {
      final path = _localCache[cacheKey]!;
      if (await File(path).exists()) {
        await OpenFilex.open(path);
        if (onSuccess != null) onSuccess();
        return;
      }
    }

    final templates = ref.read(templatesProvider).value ?? [];
    final template = templates.firstWhere(
      (t) => t.id == styleId,
      orElse: () => templates.first,
    );

    final adService = ref.read(adServiceProvider);
    final creationState = ref.read(cvCreationProvider);

    // 1. Prepare Data
    final cvId = const Uuid().v4();
    final cvData = CVData(
      id: cvId,
      userProfile: creationState.userProfile!,
      summary: creationState.summary ?? '',
      styleId: styleId,
      createdAt: DateTime.now(),
      jobTitle: creationState.jobInput?.jobTitle ?? 'Untitled CV',
      jobDescription: creationState.jobInput?.jobDescription ?? '',
    );
    final photoUrl = ref
        .read(profileControllerProvider)
        .currentProfile
        .photoUrl;

    // 2. Save Draft Immediately
    await ref.read(draftsProvider.notifier).saveFromState(creationState);

    // 3. START CONCURRENT GENERATION (Runs while Ad plays)
    final Future<List<int>> pdfFuture = ref
        .read(cvRepositoryProvider)
        .downloadPDF(
          cvData: cvData,
          templateId: styleId,
          locale: effectiveLocale,
          usePhoto: usePhoto,
          photoUrl: photoUrl,
        );

    if (template.hasFreeGeneration ||
        template.userCredits >= template.requiredCredits) {
      if (template.userCredits > 0) {
        state = state.copyWith(status: DownloadStatus.generating);
        try {
          final bytes = await pdfFuture;
          final path = await _finalizePDFExport(
            context,
            bytes,
            cvData,
            styleId,
            effectiveLocale,
            onSuccess,
          );
          _localCache[cacheKey] = path;
        } catch (e) {
          _handleError(context, e, effectiveLocale, styleId);
        }
      } else {
        // Show Ad, but PDF is already generating!
        await adService.showInterstitialAd(
          context,
          onAdClosed: () async {
            await Future.delayed(const Duration(milliseconds: 300));
            if (context.mounted) {
              state = state.copyWith(status: DownloadStatus.generating);
              try {
                final bytes = await pdfFuture;
                final path = await _finalizePDFExport(
                  context,
                  bytes,
                  cvData,
                  styleId,
                  effectiveLocale,
                  onSuccess,
                );
                _localCache[cacheKey] = path;
              } catch (e) {
                _handleError(context, e, effectiveLocale, styleId);
              }
            }
          },
        );
      }
    }
  }

  Future<String> _finalizePDFExport(
    BuildContext context,
    List<int> pdfBytes,
    CVData cvData,
    String styleId,
    String locale,
    VoidCallback? onSuccess,
  ) async {
    if (pdfBytes.length < 1000) {
      throw Exception(
        'Downloaded PDF is too small (${pdfBytes.length} bytes).',
      );
    }

    final cvDir = await CompletedCVNotifier.getStorageDir();
    final safeId = styleId
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        .toLowerCase();
    final fileName =
        'cv_${safeId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final pdfFile = File('${cvDir.path}/$fileName');
    await pdfFile.writeAsBytes(pdfBytes, flush: true);

    String? thumbnailPath;
    try {
      final thumbDir = await CompletedCVNotifier.getThumbnailDir();
      final thumbFile = File('${thumbDir.path}/${cvData.id}_thumb.png');

      final document = await PdfDocument.openData(Uint8List.fromList(pdfBytes));
      final page = await document.getPage(1);
      final pageImage = await page.render(
        width: page.width * 0.5,
        height: page.height * 0.5,
        format: PdfPageImageFormat.png,
        backgroundColor: '#FFFFFF',
      );
      if (pageImage != null) {
        await thumbFile.writeAsBytes(pageImage.bytes);
        thumbnailPath = thumbFile.path;
      }
      await page.close();
      await document.close();
    } catch (e) {
      debugPrint('Thumbnail generation failed: $e');
    }

    final completedCV = CompletedCV(
      id: cvData.id,
      jobTitle: cvData.jobTitle,
      templateId: styleId,
      pdfPath: pdfFile.path,
      thumbnailPath: thumbnailPath,
      generatedAt: DateTime.now(),
    );

    await ref.read(completedCVProvider.notifier).addCompletedCV(completedCV);

    ref.invalidate(templatesProvider);
    state = state.copyWith(status: DownloadStatus.success);

    if (context.mounted) {
      NotificationService.showSimpleNotification(
        title: AppLocalizations.of(context)!.cvGeneratedSuccess,
        body: AppLocalizations.of(context)!.cvReadyMessage(cvData.jobTitle),
        payload: {'route': '/drafts'},
      );
    }

    await OpenFilex.open(pdfFile.path);
    if (onSuccess != null) onSuccess();

    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(status: DownloadStatus.idle);
    });

    return pdfFile.path;
  }

  void _handleError(
    BuildContext context,
    dynamic e,
    String locale,
    String styleId,
  ) {
    AnalyticsService().trackEvent(
      'cv_generation_failed',
      properties: {
        'template_id': styleId,
        'error': e.toString(),
        'locale': locale,
      },
    );
    state = state.copyWith(
      status: DownloadStatus.error,
      errorMessage: e.toString(),
    );
    if (context.mounted) {
      CustomSnackBar.showError(context, e.toString());
    }
  }
}

final cvDownloadProvider =
    NotifierProvider<CVDownloadNotifier, CVDownloadState>(
      CVDownloadNotifier.new,
    );
