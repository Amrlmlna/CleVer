import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/job_input.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../providers/cv_generation_provider.dart';
import '../providers/ocr_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../../../core/providers/locale_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobInputController extends AutoDisposeAsyncNotifier<void> {
  static const String _kDraftTitleKey = 'draft_job_title';
  static const String _kDraftCompanyKey = 'draft_job_company';
  static const String _kDraftDescKey = 'draft_job_desc';

  @override
  Future<void> build() async {}

  Future<Map<String, String>> loadDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'title': prefs.getString(_kDraftTitleKey) ?? '',
      'company': prefs.getString(_kDraftCompanyKey) ?? '',
      'description': prefs.getString(_kDraftDescKey) ?? '',
    };
  }

  Future<void> saveDrafts({
    required String title,
    required String company,
    required String description,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDraftTitleKey, title);
    await prefs.setString(_kDraftCompanyKey, company);
    await prefs.setString(_kDraftDescKey, description);
  }

  Future<void> clearDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kDraftTitleKey);
    await prefs.remove(_kDraftCompanyKey);
    await prefs.remove(_kDraftDescKey);
  }

  Future<void> submit({
    required BuildContext context,
    required String title,
    required String company,
    required String description,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final masterProfile = ref.read(masterProfileProvider);

    if (masterProfile == null) {
      CustomSnackBar.showWarning(context, l10n.completeProfileFirst);
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AppLoadingScreen(
              messages: [
                l10n.validatingData,
                l10n.preparingProfile,
                l10n.continuingToForm,
              ],
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    try {
      final jobInput = JobInput(
        jobTitle: title,
        company: company.isNotEmpty ? company : null,
        jobDescription: description,
      );

      ref.read(cvCreationProvider.notifier).setJobInput(jobInput);

      final repository = ref.read(cvRepositoryProvider);
      final locale = ref.read(localeNotifierProvider);
      final creationState = ref.read(cvCreationProvider);

      final tailoredResult = await repository.tailorProfile(
        masterProfile: masterProfile,
        jobInput: jobInput,
        locale: locale.languageCode,
        options: creationState.tailoringOptions,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
        await clearDrafts();
        context.push('/create/user-data', extra: tailoredResult);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        CustomSnackBar.showError(
          context,
          l10n.analyzeProfileError(e.toString()),
        );
      }
    }
  }

  Future<void> scanJobPosting({
    required BuildContext context,
    required ImageSource source,
    required Function(JobInput) onFound,
  }) async {
    final ocrNotifier = ref.read(ocrProvider.notifier);
    bool loadingShown = false;

    final result = await ocrNotifier.scanJobPosting(
      source,
      onProcessingStart: () {
        loadingShown = true;
        _showOCRProcessingLoading(context);
      },
    );

    if (loadingShown && context.mounted) {
      Navigator.of(context).pop();
    }

    _handleOCRResult(context, result, onFound);
  }

  Future<void> scanJobPostingFromPDF({
    required BuildContext context,
    required Function(JobInput) onFound,
  }) async {
    final ocrNotifier = ref.read(ocrProvider.notifier);
    bool loadingShown = false;

    final result = await ocrNotifier.scanJobPostingFromPDF(
      onProcessingStart: () {
        loadingShown = true;
        _showOCRProcessingLoading(context);
      },
    );

    if (loadingShown && context.mounted) {
      Navigator.of(context).pop();
    }

    _handleOCRResult(context, result, onFound);
  }

  void _showOCRProcessingLoading(BuildContext context) {
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            AppLoadingScreen(
              badge: l10n.ocrScanning,
              messages: [
                l10n.analyzingText,
                l10n.identifyingVacancy,
                l10n.organizingData,
                l10n.finalizing,
              ],
            ),
      ),
    );
  }

  void _handleOCRResult(
    BuildContext context,
    OCRResult result,
    Function(JobInput) onFound,
  ) {
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;

    switch (result.status) {
      case OCRStatus.success:
        onFound(result.jobInput!);
        CustomSnackBar.showSuccess(context, l10n.jobExtractionSuccess);
      case OCRStatus.cancelled:
        break; // Just ignore cancellation
      case OCRStatus.noText:
        CustomSnackBar.showWarning(context, l10n.noTextFound);
      case OCRStatus.error:
        CustomSnackBar.showError(
          context,
          result.errorMessage ?? l10n.jobExtractionFailed,
        );
    }
  }
}

final jobInputControllerProvider =
    AutoDisposeAsyncNotifierProvider<JobInputController, void>(() {
      return JobInputController();
    });
