import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../providers/onboarding_provider.dart';
import '../providers/onboarding_auth_capture_provider.dart';
import '../../../core/services/analytics_service.dart';

import '../widgets/clever_panel/clever_certification_step.dart';
import '../widgets/clever_panel/clever_education_step.dart';
import '../widgets/clever_panel/clever_skills_step.dart';
import '../widgets/clever_panel/clever_experience_step.dart';
import '../widgets/clever_panel/clever_method_choice_step.dart';
import '../widgets/clever_panel/clever_complete_step.dart';

/// Host for panel pages 1–6, embedded in the intro page's bottom sheet.
/// Page 0 (header) renders outside this widget — the intro swaps it in —
/// so the PageView keeps a placeholder at index 0 to stay aligned with
/// [onboardingFormProvider]'s currentPage indices.
class OnboardingPage extends ConsumerStatefulWidget {
  final bool shouldTrackOnInit;
  final int initialPage;

  const OnboardingPage({
    super.key,
    this.shouldTrackOnInit = true,
    this.initialPage = 0,
  });

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController = PageController(
    initialPage: widget.initialPage,
  );

  @override
  void initState() {
    super.initState();

    if (widget.shouldTrackOnInit) {
      AnalyticsService().trackOnboardingStep('data_input', 0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleImportSuccess(profile) {
    final notifier = ref.read(onboardingFormProvider.notifier);

    notifier.populateFromImport(profile);
    notifier.skipToFinal();

    if (mounted) {
      CustomSnackBarHelper.showSuccess(
        context,
        AppLocalizations.of(context)!.cvImportedSuccess,
      );
    }
  }

  void _handleManualEntry() {
    ref.read(onboardingFormProvider.notifier).nextPage();
  }

  Future<void> _finishOnboarding() async {
    await ref.read(onboardingFormProvider.notifier).submit();
    AnalyticsService().trackEvent('onboarding_completed');

    if (mounted) {
      ref.read(onboardingAuthCaptureProvider.notifier).state = true;
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(
      onboardingFormProvider.select((s) => s.currentPage),
    );

    void nextPage() {
      ref.read(onboardingFormProvider.notifier).nextPage();
    }

    ref.listen(onboardingFormProvider, (prev, next) {
      if (prev?.currentPage != next.currentPage) {
        _pageController.animateToPage(
          next.currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        AnalyticsService().trackOnboardingStep('data_input', next.currentPage);
      }
    });

    // Embedded in the Clever panel sheet: the sheet provides the chrome
    // (drag handle, orange container), so no legacy shell here.
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Index 0: the header step renders OUTSIDE this PageView (intro
        // page swaps it in) — placeholder keeps indices aligned.
        const SizedBox.shrink(),
        CleverMethodChoiceStep(
          onManualEntry: _handleManualEntry,
          onImportSuccess: _handleImportSuccess,
        ),
        CleverExperienceStep(
          onNext: currentPage < 6 ? nextPage : _finishOnboarding,
        ),
        CleverEducationStep(
          onNext: currentPage < 6 ? nextPage : _finishOnboarding,
        ),
        CleverCertificationStep(
          onNext: currentPage < 6 ? nextPage : _finishOnboarding,
        ),
        CleverSkillsStep(
          onNext: currentPage < 6 ? nextPage : _finishOnboarding,
        ),
        CleverCompleteStep(onFinish: _finishOnboarding),
      ],
    );
  }
}

/// Legacy-parity snackbar shim (success styling matches the Clever look).
class CustomSnackBarHelper {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: CleverTypography.body.copyWith(color: CleverColors.textOnDark),
        ),
        backgroundColor: CleverColors.bgSuccess,
      ),
    );
  }
}
