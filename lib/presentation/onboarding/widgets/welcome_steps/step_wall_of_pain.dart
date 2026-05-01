import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../onboarding_step_screen.dart';
import '../onboarding_tweet_card.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class StepWallOfPain extends StatelessWidget {
  final VoidCallback onNext;

  const StepWallOfPain({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return OnboardingStepScreen(
      key: const ValueKey('step0'),
      title: l10n.onboardingStepWallTitle,
      subtitle: l10n.onboardingStepWallSub,
      isLargeHeader: false,
      useShaderMask: true,
      children: [
        OnboardingTweetCard(
          handle: l10n.onboardingTweetHandle1,
          content: l10n.onboardingTweetContent1,
          delay: 400.ms,
        ),
        OnboardingTweetCard(
          handle: l10n.onboardingTweetHandle2,
          content: l10n.onboardingTweetContent2,
          delay: 800.ms,
        ),
        OnboardingTweetCard(
          handle: l10n.onboardingTweetHandle3,
          content: l10n.onboardingTweetContent3,
          delay: 1200.ms,
        ),
      ],
      footer: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.onSurface,
            foregroundColor: colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            l10n.next.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
