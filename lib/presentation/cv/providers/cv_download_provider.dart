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
import '../../../core/services/payment_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../auth/utils/auth_guard.dart';
import '../../../domain/entities/cv_data.dart';
import '../../../domain/entities/completed_cv.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../drafts/providers/draft_provider.dart';
import '../../drafts/providers/completed_cv_provider.dart';
import '../../templates/providers/template_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';

enum DownloadStatus {
  idle,
  loading,
  generating,
  success,
  error,
}

class CVDownloadState {
  final DownloadStatus status;
  final String? errorMessage;

  const CVDownloadState({
    this.status = DownloadStatus.idle,
    this.errorMessage,
  });

  CVDownloadState copyWith({
    DownloadStatus? status,
    String? errorMessage,
  }) {
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

  String _buildCacheKey(String styleId) {
    final creationState = ref.read(cvCreationProvider);
    final raw = jsonEncode({
      'profile': creationState.userProfile?.toJson(),
      'summary': creationState.summary,
      'jobInput': creationState.jobInput?.toJson(),
      'styleId': styleId,
    });
    return md5.convert(utf8.encode(raw)).toString();
  }

  Future<void> attemptDownload({
    required BuildContext context,
    required String styleId,
  }) async {
    if (state.status == DownloadStatus.generating) {
      debugPrint('Download already in progress. Ignoring request.');
      return;
    }

    final cacheKey = _buildCacheKey(styleId);

    if (_localCache.containsKey(cacheKey)) {
      final file = File(_localCache[cacheKey]!);
      if (await file.exists()) {
        debugPrint('Opening cached PDF from: ${file.path}');
        await OpenFilex.open(file.path);
        return;
      }
    }

    final templates = ref.read(templatesProvider).value ?? [];
    final template = templates.firstWhere(
      (t) => t.id == styleId,
      orElse: () => templates.first,
    );

    if (template.userCredits > 0) {
      await _generateAndOpenPDF(context, styleId);
      return;
    }

    if (template.currentUsage >= 2) {
      if (!AuthGuard.check(context, featureTitle: AppLocalizations.of(context)!.authWallBuyCredits, featureDescription: AppLocalizations.of(context)!.authWallBuyCreditsDesc)) return;

      final purchased = await PaymentService.presentPaywall();
      if (purchased) {
        ref.invalidate(templatesProvider);
      }
      return;
    }

    await adService.showInterstitialAd(
      context,
      onAdClosed: () {
        _generateAndOpenPDF(context, styleId);
      },
    );
  }

  Future<void> _generateAndOpenPDF(BuildContext context, String styleId) async {
    state = state.copyWith(status: DownloadStatus.generating);
    
    try {
      final creationState = ref.read(cvCreationProvider);
      
      await ref.read(draftsProvider.notifier).saveFromState(creationState);

      final cvId = const Uuid().v4();
      final cvData = CVData(
        id: cvId,
        userProfile: creationState.userProfile!,
        summary: creationState.summary!,
        styleId: styleId,
        createdAt: DateTime.now(),
        jobTitle: creationState.jobInput!.jobTitle,
        jobDescription: creationState.jobInput!.jobDescription ?? '',
      );
      final locale = ref.read(localeNotifierProvider);
      final pdfBytes = await ref.read(cvRepositoryProvider).downloadPDF(
        cvData: cvData,
        templateId: styleId,
        locale: locale.languageCode,
      );
      if (pdfBytes.length < 1000) {
        throw Exception('Downloaded PDF is too small (${pdfBytes.length} bytes). It might be an error message.');
      }

      final cvDir = await CompletedCVNotifier.getStorageDir();
      final safeId = styleId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase();
      final fileName = 'cv_${safeId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final pdfFile = File('${cvDir.path}/$fileName');
      await pdfFile.writeAsBytes(pdfBytes, flush: true);

      String? thumbnailPath;
      try {
        final thumbDir = await CompletedCVNotifier.getThumbnailDir();
        final thumbFile = File('${thumbDir.path}/${cvId}_thumb.png');
        
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
        id: cvId,
        jobTitle: cvData.jobTitle,
        templateId: styleId,
        pdfPath: pdfFile.path,
        thumbnailPath: thumbnailPath,
        generatedAt: DateTime.now(),
      );
      await ref.read(completedCVProvider.notifier).addCompletedCV(completedCV);
      
      final result = await OpenFilex.open(pdfFile.path);
      
      _localCache[_buildCacheKey(styleId)] = pdfFile.path;
      
      ref.invalidate(templatesProvider);
      state = state.copyWith(status: DownloadStatus.success);

      if (context.mounted) {
        NotificationService.showSimpleNotification(
          title: AppLocalizations.of(context)!.cvGeneratedSuccess,
          body: AppLocalizations.of(context)!.cvReadyMessage(cvData.jobTitle),
          payload: '/drafts',
        );
      }

      if (result.type != ResultType.done) {
        if (context.mounted) {
          CustomSnackBar.showError(
            context,
            AppLocalizations.of(context)!.pdfOpenError(result.message),
          );
        }
      }

    } catch (e) {
      state = state.copyWith(
        status: DownloadStatus.error,
        errorMessage: e.toString(),
      );
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          AppLocalizations.of(context)!.pdfGenerateError(e.toString()),
        );
      }
    } finally {
      state = state.copyWith(status: DownloadStatus.idle);
    }
  }
}

final cvDownloadProvider = NotifierProvider<CVDownloadNotifier, CVDownloadState>(CVDownloadNotifier.new);
