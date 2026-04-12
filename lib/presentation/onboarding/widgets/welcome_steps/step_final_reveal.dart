import 'package:flutter/material.dart';
import '../../../auth/widgets/gradient_button.dart';
import '../onboarding_carousel_screen.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class StepFinalReveal extends StatelessWidget {
  final VoidCallback onNext;

  const StepFinalReveal({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return OnboardingCarouselScreen(
      key: const ValueKey('step6'),
      headline: l10n.onboardingHeadline7,
      imageAsset: 'assets/images/onboarding_screen_6.png',
      isCentered: true,
      footer: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              text: l10n.getStarted,
              onPressed: onNext,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.takesLessThan3Min,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
