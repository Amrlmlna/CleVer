import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/services/ad_service.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../auth/utils/auth_guard.dart';
import '../../../domain/entities/cv_data.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../drafts/providers/draft_provider.dart';
import '../../templates/providers/template_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

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
  // Simple session cache: templateId -> localFilePath
  final Map<String, String> _localCache = {};

  @override
  CVDownloadState build() {
    return const CVDownloadState();
  }

  Future<void> attemptDownload({
    required BuildContext context,
    required String styleId,
  }) async {
    if (state.status == DownloadStatus.generating) {
      debugPrint('Download already in progress. Ignoring request.');
      return;
    }

    if (_localCache.containsKey(styleId)) {
      final file = File(_localCache[styleId]!);
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
      if (!AuthGuard.check(context)) return;

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

      final cvData = CVData(
        id: const Uuid().v4(),
        userProfile: creationState.userProfile!,
        summary: creationState.summary!,
        styleId: styleId,
        createdAt: DateTime.now(),
        jobTitle: creationState.jobInput!.jobTitle,
        jobDescription: creationState.jobInput!.jobDescription ?? '',
      );

      final pdfBytes = await ref.read(cvRepositoryProvider).downloadPDF(
        cvData: cvData,
        templateId: styleId,
      );

      if (pdfBytes.length < 1000) {
        throw Exception('Downloaded PDF is too small (${pdfBytes.length} bytes). It might be an error message.');
      }

      final output = await getTemporaryDirectory();
      final safeId = styleId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase();
      final fileName = 'cv_${safeId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${output.path}/$fileName');
      
      await file.writeAsBytes(pdfBytes, flush: true);
      
      final result = await OpenFilex.open(file.path);
      
      _localCache[styleId] = file.path;
      
      ref.invalidate(templatesProvider);
      state = state.copyWith(status: DownloadStatus.success);

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
