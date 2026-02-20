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
  @override
  CVDownloadState build() {
    return const CVDownloadState();
  }

  Future<void> attemptDownload({
    required BuildContext context,
    required String styleId,
  }) async {
    final templates = ref.read(templatesProvider).value ?? [];
    final template = templates.firstWhere(
      (t) => t.id == styleId,
      orElse: () => templates.first,
    );

    // 1. Check if user has credits (Premium behavior)
    if (template.userCredits > 0) {
      await _generateAndOpenPDF(context, styleId);
      return;
    }

    // 2. Check if template is locked (Usage >= 2 and No Credits)
    if (template.currentUsage >= 2) {
      // Use a post-frame callback or check mounted in UI? 
      // Since we passed context, we can show logic here, but ideally logic returns a "ShowPaywall" state.
      // However, for this refactor, we are keeping the side-effects here for simplicity as per plan.
      if (!AuthGuard.check(context)) return;

      final purchased = await PaymentService.presentPaywall();
      if (purchased) {
        ref.invalidate(templatesProvider);
      }
      return;
    }

    // 3. Free Usage (Usage < 2) -> Show Ad then Generate
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
      
      // Ensure data is saved first
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

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/cv_${styleId.toLowerCase()}.pdf');
      await file.writeAsBytes(pdfBytes);
      
      final result = await OpenFilex.open(file.path);
      
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
