import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/clever/clever_button.dart';
import '../../common/widgets/clever/clever_mascot.dart';
import '../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../common/widgets/clever/clever_option_tile.dart';
import '../../common/widgets/clever/clever_progress_bar.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_dimensions.dart';
import '../../../core/theme/clever/clever_motion.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../legal/pages/clever_legal_placeholder_page.dart';
import '../providers/clever_welcome_provider.dart';
import '../widgets/clever_welcome/clever_application_slider.dart';
import '../widgets/clever_welcome/clever_budget_picker.dart';

const _budgetLabels = ['Rp0 - 20.000', 'Rp30.000', 'Rp50.000', 'Rp100.000+'];

class CleverWelcomeQuestionnairePage extends ConsumerWidget {
  const CleverWelcomeQuestionnairePage({super.key, this.onCompleted});

  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cleverWelcomeProvider);
    final notifier = ref.read(cleverWelcomeProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: CleverColors.bgCanvas,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _GlowBlobs()),
            if (state.step == CleverWelcomeState.stepCount - 1)
              Positioned(
                left: -67,
                top: MediaQuery.sizeOf(context).height * 0.316,
                child: const CleverMascot(
                  variant: CleverMascotVariant.welcomeStep7,
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: CleverProgressBar(index: state.step + 1, total: 8),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: CleverMotion.transition,
                    switchInCurve: CleverMotion.transitionCurve,
                    child: _StepBody(
                      key: ValueKey(state.step),
                      step: state.step,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _BottomNav(
                    state: state,
                    notifier: notifier,
                    onCompleted: onCompleted,
                    l10n: l10n,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft radial glows present on every staging welcome frame: top-right and
/// bottom-left, 334×336, royal-blue fading into the canvas.
class _GlowBlobs extends StatelessWidget {
  const _GlowBlobs();

  @override
  Widget build(BuildContext context) {
    final blob = BoxDecoration(
      gradient: RadialGradient(
        colors: [
          CleverColors.bgOnboarding.withValues(alpha: 0.4),
          CleverColors.bgCanvas.withValues(alpha: 0.27),
        ],
      ),
    );

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -70,
            child: Container(width: 334, height: 336, decoration: blob),
          ),
          Positioned(
            bottom: -70,
            left: -70,
            child: Container(width: 334, height: 336, decoration: blob),
          ),
        ],
      ),
    );
  }
}

class _StepBody extends ConsumerWidget {
  const _StepBody({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cleverWelcomeProvider);
    final notifier = ref.read(cleverWelcomeProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return switch (step) {
      0 => _QuestionStep(
        title: l10n.cleverWelcomePersonaTitle,
        isHero: true,
        child: Column(
          children: [
            _option(
              l10n.cleverPersonaStudent,
              state.persona == CleverPersona.student,
              () => notifier.selectPersona(CleverPersona.student),
            ),
            _option(
              l10n.cleverPersonaJobSeeker,
              state.persona == CleverPersona.jobSeeker,
              () => notifier.selectPersona(CleverPersona.jobSeeker),
            ),
            _option(
              l10n.cleverPersonaCareerSwitcher,
              state.persona == CleverPersona.careerSwitcher,
              () => notifier.selectPersona(CleverPersona.careerSwitcher),
            ),
          ],
        ),
      ),
      1 => _QuestionStep(
        title: l10n.cleverWelcomeBudgetTitle,
        child: CleverBudgetPicker(
          values: _budgetLabels,
          selectedIndex: CleverBudget.values.indexOf(
            state.budget ?? CleverBudget.under20k,
          ),
          onSelected: (i) => notifier.selectBudget(CleverBudget.values[i]),
        ),
      ),
      2 => _QuestionStep(
        title: l10n.cleverWelcomeSingleCvTitle,
        child: Column(
          children: [
            _option(
              l10n.cleverYes,
              state.hasSingleCv == true,
              () => notifier.selectSingleCv(true),
              icon: Icons.thumb_up_outlined,
            ),
            _option(
              l10n.cleverNo,
              state.hasSingleCv == false,
              () => notifier.selectSingleCv(false),
              icon: Icons.thumb_down_outlined,
            ),
          ],
        ),
      ),
      3 => _QuestionStep(
        title: l10n.cleverWelcomeAppsTitle,
        child: CleverApplicationSlider(
          value: state.applicationsPerDay,
          min: 10,
          max: 100,
          onChanged: notifier.setApplicationsPerDay,
        ),
      ),
      4 => _QuestionStep(
        title: l10n.cleverWelcomeReasonTitle,
        child: Column(
          children: [
            for (final reason in CleverReason.values)
              _option(
                _reasonLabel(l10n, reason),
                state.reasons.contains(reason),
                () => notifier.toggleReason(reason),
              ),
          ],
        ),
      ),
      5 => _SocialProofStep(headline: l10n.cleverWelcomeSocialProofTitle),
      _ => _ConsentStep(state: state, notifier: notifier),
    };
  }

  String _reasonLabel(AppLocalizations l10n, CleverReason reason) =>
      switch (reason) {
        CleverReason.companyResearch => l10n.cleverReasonCompanyResearch,
        CleverReason.repromptAi => l10n.cleverReasonRepromptAi,
        CleverReason.manualTemplate => l10n.cleverReasonManualTemplate,
        CleverReason.repeatedForms => l10n.cleverReasonRepeatedForms,
      };

  Widget _option(
    String label,
    bool selected,
    VoidCallback onTap, {
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CleverOptionTile(
        label: label,
        selected: selected,
        trailingIcon: icon,
        onTap: onTap,
      ),
    );
  }
}

class _QuestionStep extends StatelessWidget {
  const _QuestionStep({
    required this.title,
    required this.child,
    this.isHero = false,
  });

  final String title;
  final Widget child;
  final bool isHero;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: isHero ? 72 : 104),
            Text(
              title,
              style: isHero
                  ? CleverTypography.h1.copyWith(
                      color: CleverColors.textPrimary,
                    )
                  : CleverTypography.h4.copyWith(
                      color: CleverColors.textPrimary,
                    ),
            ),
            const Spacer(flex: 2),
            child,
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class _SocialProofStep extends StatelessWidget {
  const _SocialProofStep({required this.headline});

  final String headline;

  @override
  Widget build(BuildContext context) {
    final marker = '100';
    final markerIndex = headline.indexOf(marker);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Text.rich(
          TextSpan(
            text: headline.substring(0, markerIndex),
            children: [
              TextSpan(
                text: marker,
                style: CleverTypography.h1.copyWith(
                  color: CleverColors.textAccent,
                ),
              ),
              TextSpan(text: headline.substring(markerIndex + marker.length)),
            ],
            style: CleverTypography.h1.copyWith(
              color: CleverColors.textPrimary,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ConsentStep extends StatelessWidget {
  const _ConsentStep({required this.state, required this.notifier});

  final CleverWelcomeState state;
  final CleverWelcomeNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 36),
            Text(
              l10n.cleverWelcomeThanksTitle,
              textAlign: TextAlign.center,
              style: CleverTypography.h1.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.cleverWelcomePrivacyNote,
              textAlign: TextAlign.center,
              style: CleverTypography.bodyStrong.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
            const Spacer(),
            _ConsentRow(
              checked: state.consented,
              onChanged: notifier.setConsented,
              doc: CleverLegalDoc.privacy,
            ),
          ],
        ),
      ),
    );
  }
}

/// Single consent line on the dark mascot; all foreground colors on-dark.
class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.checked,
    required this.onChanged,
    required this.doc,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final CleverLegalDoc doc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Checkbox(
                value: checked,
                onChanged: (value) => onChanged(value ?? false),
                activeColor: CleverColors.bgAction,
                checkColor: CleverColors.textOnDark,
                side: const BorderSide(
                  color: CleverColors.textOnDark,
                  width: CleverStrokes.hairline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.cleverConsentLine,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: CleverTypography.bodySm.copyWith(
                  color: CleverColors.textOnDark,
                ),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.onboardingLegal, extra: doc),
          style: TextButton.styleFrom(
            foregroundColor: CleverColors.textOnDark,
            padding: const EdgeInsets.only(left: 38, top: 4, bottom: 4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.cleverReadMore,
                style: CleverTypography.bodySm.copyWith(
                  color: CleverColors.textOnDark,
                ),
              ),
              const Icon(Icons.arrow_outward, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.state,
    required this.notifier,
    required this.onCompleted,
    required this.l10n,
  });

  final CleverWelcomeState state;
  final CleverWelcomeNotifier notifier;
  final VoidCallback? onCompleted;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final enabled = state.canContinue;

    if (state.step == 0) {
      return CleverButton(
        label: l10n.next,
        onTap: enabled ? notifier.next : null,
      );
    }

    final isFinalStep = state.step == CleverWelcomeState.stepCount - 1;

    return CleverNavActionBar(
      backLabel: l10n.back,
      tone: isFinalStep ? CleverNavTone.cream : CleverNavTone.midnight,
      onBack: notifier.back,
      onNext: () {
        if (!enabled) return;
        if (state.isComplete) {
          onCompleted?.call();
        } else {
          notifier.next();
        }
      },
    );
  }
}
