import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/services/ad_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../domain/entities/cv_data.dart';
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

    await ref.read(draftsProvider.notifier).saveFromState(creationState);

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
          final path = await _processResult(
            context,
            bytes,
            cvData,
            styleId,
            onSuccess,
          );
          _localCache[cacheKey] = path;
        } catch (e) {
          _handleError(context, e, effectiveLocale, styleId);
        }
      } else {
        await adService.showInterstitialAd(
          context,
          onAdClosed: () async {
            await Future.delayed(const Duration(milliseconds: 300));
            if (context.mounted) {
              state = state.copyWith(status: DownloadStatus.generating);
              try {
                final bytes = await pdfFuture;
                final path = await _processResult(
                  context,
                  bytes,
                  cvData,
                  styleId,
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

  Future<String> _processResult(
    BuildContext context,
    List<int> bytes,
    CVData cvData,
    String styleId,
    VoidCallback? onSuccess,
  ) async {
    final completedCV = await PDFExportService.finalizeExport(
      pdfBytes: bytes,
      cvId: cvData.id,
      jobTitle: cvData.jobTitle,
      styleId: styleId,
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

    await OpenFilex.open(completedCV.pdfPath);
    if (onSuccess != null) onSuccess();

    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(status: DownloadStatus.idle);
    });

    return completedCV.pdfPath;
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
