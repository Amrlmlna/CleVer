import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/entities/user_profile.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/animated_check_icon.dart';

/// Displays contextual feedback based on profile completeness.
/// Used in onboarding step 7/7 to provide personalized encouragement.
///
/// Redesigned with a strict black/white minimalist composition —
/// no accent colors, no morphing graphics, no decorative cards.
class OnboardingFeedbackState extends StatelessWidget {
  final UserProfile profile;
  final String completenessState; // 'complete' | 'partial' | 'empty'

  const OnboardingFeedbackState({
    super.key,
    required this.profile,
    required this.completenessState,
  });

  @override
  Widget build(BuildContext context) {
    switch (completenessState) {
      case 'complete':
        return _CompleteState(profile: profile);
      case 'partial':
        return _PartialState();
      case 'empty':
      default:
        return _EmptyState();
    }
  }
}

// ─── Complete State ──────────────────────────────────────────────────────────

class _CompleteState extends StatelessWidget {
  final UserProfile profile;
  const _CompleteState({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final firstName = profile.fullName.split(' ').first;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Minimal check circle — solid black/white, no glow, no morph
        Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
              child: AnimatedCheckIcon(
                size: 36,
                color: colorScheme.surface,
                strokeWidth: 4,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1.0, 1.0),
              curve: Curves.easeOutBack,
              duration: 600.ms,
            ),

        const SizedBox(height: 40),

        // Hero headline — stark, tight, pure onSurface
        Text(
              '${l10n.onboardingFeedbackCompleteFeatureTitle}\n$firstName.',
              textAlign: TextAlign.center,
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
                height: 1.15,
                letterSpacing: -1.2,
              ),
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 500.ms)
            .slideY(begin: 0.08, end: 0, curve: Curves.easeOut),

        const SizedBox(height: 16),

        // Body — subdued, secondary
        Text(
          l10n.onboardingFeedbackCompleteMessage,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
            letterSpacing: -0.1,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
      ],
    );
  }
}

// ─── Partial State ───────────────────────────────────────────────────────────

class _PartialState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Minimal icon circle
        Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.trending_up_rounded,
                color: colorScheme.surface,
                size: 36,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1.0, 1.0),
              curve: Curves.easeOutBack,
              duration: 600.ms,
            ),

        const SizedBox(height: 40),

        // Headline
        Text(
              l10n.onboardingFeedbackPartialTitle,
              textAlign: TextAlign.center,
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
                height: 1.15,
                letterSpacing: -1.2,
              ),
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 500.ms)
            .slideY(begin: 0.08, end: 0, curve: Curves.easeOut),

        const SizedBox(height: 16),

        // Body
        Text(
          l10n.onboardingFeedbackPartialMessage,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
            letterSpacing: -0.1,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
      ],
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Minimal icon circle — inverted from the others for visual hierarchy
        Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: colorScheme.onSurface,
                size: 36,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1.0, 1.0),
              curve: Curves.easeOutBack,
              duration: 600.ms,
            ),

        const SizedBox(height: 40),

        // Headline
        Text(
              l10n.onboardingFeedbackEmptyTitle,
              textAlign: TextAlign.center,
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
                height: 1.15,
                letterSpacing: -1.2,
              ),
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 500.ms)
            .slideY(begin: 0.08, end: 0, curve: Curves.easeOut),

        const SizedBox(height: 16),

        // Body
        Text(
          l10n.onboardingFeedbackEmptyMessage,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
            letterSpacing: -0.1,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
      ],
    );
  }
}
