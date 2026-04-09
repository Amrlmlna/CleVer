import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../core/theme/app_colors.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

/// Displays contextual feedback based on profile completeness.
/// Used in onboarding step 7/7 to provide personalized encouragement.
///
/// Three states:
/// - **complete**: Celebration UI with confetti-like animation
/// - **partial**: Progress indicator with "great start" message
/// - **empty**: Relaxed, low-pressure UI for skippers
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

class _CompleteState extends StatefulWidget {
  final UserProfile profile;

  const _CompleteState({required this.profile});

  @override
  State<_CompleteState> createState() => _CompleteStateState();
}

class _CompleteStateState extends State<_CompleteState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Animated celebration icon
        FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.celebration_rounded,
                color: colorScheme.onPrimaryContainer,
                size: 32,
              ),
            ),
          ),
        ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),

        const SizedBox(height: 24),

        // Personalized headline
        Text(
          l10n.onboardingFeedbackCompleteTitle(
            widget.profile.fullName.split(' ').first,
          ),
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            letterSpacing: 0.5,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

        const SizedBox(height: 12),

        // Success message
        Text(
          l10n.onboardingFeedbackCompleteMessage,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

        const SizedBox(height: 20),

        // Feature highlights
        _buildFeatureCard(
          context,
          icon: Icons.star_rounded,
          title: 'Top Tier Profile',
          subtitle: 'Kamu di antara kandidat paling siap.',
        ).animate().fadeIn(delay: 800.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.onPrimary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.labelSmall?.copyWith(
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
        // Progress icon container
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.trending_up_rounded,
            color: colorScheme.onPrimaryContainer,
            size: 32,
          ),
        ).animate().fadeIn(duration: 600.ms).scale(delay: 100.ms),

        const SizedBox(height: 24),

        // Headline
        Text(
          l10n.onboardingFeedbackPartialTitle,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            letterSpacing: 0.5,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

        const SizedBox(height: 12),

        // Message
        Text(
          l10n.onboardingFeedbackPartialMessage,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

        const SizedBox(height: 20),

        // Subtle hint
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.onboardingFeedbackGetSmarterHint,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Relaxed icon - coffee cup vibe
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.self_improvement_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 32,
          ),
        ).animate().fadeIn(duration: 600.ms).shimmer(delay: 500.ms, duration: 1500.ms),

        const SizedBox(height: 24),

        // Relaxed headline
        Text(
          AppLocalizations.of(context)!.onboardingFeedbackEmptyTitle,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            letterSpacing: 0.5,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

        const SizedBox(height: 12),

        // Low-pressure message
        Text(
          AppLocalizations.of(context)!.onboardingFeedbackEmptyMessage,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

        const SizedBox(height: 20),

        // Friendly hint
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.accentBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: AppColors.accentBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.onboardingFeedbackGetSmarterHint,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.accentBlueDark,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
      ],
    );
  }
}
