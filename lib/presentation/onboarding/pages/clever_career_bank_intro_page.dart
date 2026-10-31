import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_dimensions.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/clever/clever_button.dart';
import '../widgets/clever_panel/clever_ufo_illustration.dart';

/// InputStep1 — the career-bank pitch screen (8/8). "Mulai sekarang" opens
/// the input panel.
class CleverCareerBankIntroPage extends StatelessWidget {
  const CleverCareerBankIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: CleverColors.bgCanvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 21),
              child: _IntroProgressBar(),
            ),
            const SizedBox(height: CleverSpacing.space24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Text(
                'career bank ',
                style: CleverTypography.display.copyWith(
                  color: CleverColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: CleverSpacing.space8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Text(
                l10n.cleverIntroTagline,
                style: CleverTypography.bodyStrong.copyWith(
                  color: CleverColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: 402,
                    height: 419,
                    child: const CleverUfoIllustration(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                l10n.cleverIntroSupport,
                textAlign: TextAlign.center,
                style: CleverTypography.bodySm.copyWith(
                  color: CleverColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: CleverSpacing.space24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: CleverButton(
                label: l10n.cleverIntroCta,
                style: CleverButtonStyle.action,
                height: 58,
                labelStyle: CleverTypography.h3.copyWith(
                  color: CleverColors.textOnDark,
                ),
                onTap: () => context.push(AppRoutes.onboardingForm),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// The intro's progress bar differs from the welcome steps: orange gradient
/// line with the counter at body-sm.
class _IntroProgressBar extends StatelessWidget {
  const _IntroProgressBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.5),
            child: Container(
              height: 5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF9812E), CleverColors.bgAction],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: CleverSpacing.space8),
        Text(
          '8/8',
          style: CleverTypography.bodySm.copyWith(
            color: CleverColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
