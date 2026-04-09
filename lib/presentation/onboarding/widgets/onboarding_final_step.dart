import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingFinalStep extends StatefulWidget {
  const OnboardingFinalStep({super.key});

  @override
  State<OnboardingFinalStep> createState() => _OnboardingFinalStepState();
}

class _OnboardingFinalStepState extends State<OnboardingFinalStep>
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
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    // Slight delay so it feels like a reveal
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),

          // Animated success checkmark
          FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.accentBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 44,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Main headline
          FadeTransition(
            opacity: _fadeAnim,
            child: Text(
              l10n.onboardingFinalMessage,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // What's unlocked section
          FadeTransition(
            opacity: _fadeAnim,
            child: _FeatureUnlockCard(
              icon: Icons.person_outline_rounded,
              title: 'master profile',
              subtitle: 'data kamu tersimpan — tinggal pilih.',
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),

          const SizedBox(height: 10),

          FadeTransition(
            opacity: _fadeAnim,
            child: _FeatureUnlockCard(
              icon: Icons.auto_awesome_outlined,
              title: 'cv tailor ai',
              subtitle: 'bikin cv relevan dalam hitungan detik.',
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),

          const SizedBox(height: 10),

          FadeTransition(
            opacity: _fadeAnim,
            child: _FeatureUnlockCard(
              icon: Icons.grid_view_rounded,
              title: '20+ template siap pakai',
              subtitle: 'pilih, sesuaikan, ekspor. beres.',
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FeatureUnlockCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _FeatureUnlockCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
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
          Icon(
            Icons.lock_open_rounded,
            size: 18,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
