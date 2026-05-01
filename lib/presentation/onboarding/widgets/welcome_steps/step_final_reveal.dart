import 'package:flutter/material.dart';
import '../onboarding_carousel_screen.dart';
import '../../../home/widgets/mascot_header.dart';
import '../../../home/models/mascot_state.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class StepFinalReveal extends StatelessWidget {
  final VoidCallback onNext;

  const StepFinalReveal({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return OnboardingCarouselScreen(
      key: const ValueKey('step6'),
      headline: l10n.onboardingHeadline7,
      header: Container(
        width: double.infinity,
        height: 380,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(48),
            bottomRight: Radius.circular(48),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MascotHeader(
              expression: MascotExpression.smiling,
              mascotColor: colorScheme.onSurface,
            ),
          ],
        ),
      ),
      isCentered: true,
      footer: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.onSurface,
                foregroundColor: colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.getStarted.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
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
