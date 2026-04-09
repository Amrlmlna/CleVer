import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../core/theme/app_colors.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

/// Displays contextual feedback based on profile completeness.
/// Used in onboarding step 7/7 to provide personalized encouragement.
///
/// Enhanced with "Hero Typography" and a "Morphing Entrance" for 
/// a premium, alive feel.
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

/// Helper widget to handle the "Pill to Circle" morphing entrance
class _MorphingGraphic extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final bool hasGlow;

  const _MorphingGraphic({
    required this.child,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background Glow (if enabled)
          if (hasGlow)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 800.ms).scale(begin: const Offset(0.5, 0.5)),

          // The Morphing Container
          // It starts as a "Pill" (Button shape) and grows into a large Circle/Rect
          // Since it triggers on mount, we use flutter_animate to morph its geometry
          child
              .animate()
              // Start from button position (approx bottom of screen - center)
              .moveY(begin: 120, end: 0, curve: Curves.easeOutBack, duration: 800.ms)
              // Grow size and adjust shape
              .custom(
                duration: 800.ms,
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  // value 0 -> 1
                  final width = lerpDouble(120, 100, value); // Start wider like a button
                  final height = lerpDouble(52, 100, value); // Start short like a button
                  final radius = lerpDouble(16, 50, value); // Start with btn radius

                  return Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(radius ?? 16),
                      boxShadow: [
                        BoxShadow(
                          color: backgroundColor.withValues(alpha: 0.15),
                          blurRadius: 20 * value,
                          offset: Offset(0, 10 * value),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: lerpDouble(24, 42, value),
                    ),
                  );
                },
              ),
              
          // Extra Success Sparks (decorative)
          if (hasGlow)
            ...List.generate(4, (i) {
              return Positioned(
                left: 50 + (40 * (i % 2 == 0 ? 1 : -1)),
                top: 50 + (40 * (i < 2 ? 1 : -1)),
                child: Icon(Icons.auto_awesome, size: 14, color: backgroundColor)
                    .animate(onPlay: (c) => c.repeat())
                    .scale(duration: 1000.ms, begin: const Offset(0.5, 0.5))
                    .fadeOut(delay: 500.ms),
              );
            }),
        ],
      ),
    );
  }

  double? lerpDouble(num a, num b, double t) => a + (b - a) * t;
}

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
      children: [
        const SizedBox(height: 10),
        
        // Morphing Hero
        _MorphingGraphic(
          backgroundColor: colorScheme.primaryContainer,
          icon: Icons.celebration_rounded,
          iconColor: colorScheme.onPrimaryContainer,
          hasGlow: true,
          child: const SizedBox(), // The morphed container is built in the helper
        ),

        const SizedBox(height: 48),

        // Hero Typography
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Sangat Bagus,\n',
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              ),
              TextSpan(
                text: firstName,
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.accentBlue,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              ),
              TextSpan(
                text: '!',
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 16),

        // Success message
        Text(
          l10n.onboardingFeedbackCompleteMessage,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 600.ms),

        const SizedBox(height: 32),

        // Feature highlight - bigger and centered
        _buildFeatureCard(
          context,
          icon: Icons.star_rounded,
          title: l10n.onboardingFeedbackCompleteFeatureTitle,
          subtitle: l10n.onboardingFeedbackCompleteFeatureSubtitle,
        ).animate().fadeIn(delay: 800.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentBlue,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentBlue.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PartialState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 10),
        
        // Morphing Hero
        _MorphingGraphic(
          backgroundColor: colorScheme.primaryContainer,
          icon: Icons.auto_awesome_rounded,
          iconColor: colorScheme.onPrimaryContainer,
          hasGlow: true,
          child: const SizedBox(),
        ),

        const SizedBox(height: 48),

        // Headline
        Text(
          l10n.onboardingFeedbackPartialTitle,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
            letterSpacing: -1.0,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 16),

        // Message
        Text(
          l10n.onboardingFeedbackPartialMessage,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 600.ms),

        const SizedBox(height: 32),

        // Subtle hint
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 24, color: AppColors.accentBlue),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  l10n.onboardingFeedbackGetSmarterHint,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const SizedBox(height: 10),
        
        // Morphing Hero
        _MorphingGraphic(
          backgroundColor: colorScheme.surfaceContainerHighest,
          icon: Icons.self_improvement_rounded,
          iconColor: colorScheme.onSurfaceVariant,
          child: const SizedBox(),
        ),

        const SizedBox(height: 48),

        // Relaxed headline
        Text(
          l10n.onboardingFeedbackEmptyTitle,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
            letterSpacing: -1.2,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

        const SizedBox(height: 16),

        // Low-pressure message
        Text(
          l10n.onboardingFeedbackEmptyMessage,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 600.ms),

        const SizedBox(height: 32),

        // Friendly hint
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.accentBlue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_mosaic_rounded, size: 24, color: AppColors.accentBlue),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  l10n.onboardingFeedbackGetSmarterHint,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.accentBlueDark,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
      ],
    );
  }
}
