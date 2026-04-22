import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/widgets/gradient_button.dart';
import '../onboarding_step_screen.dart';

class StepComparison extends StatelessWidget {
  final VoidCallback onNext;

  const StepComparison({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return OnboardingStepScreen(
      key: const ValueKey('step5'),
      title: l10n.onboardingComparisonTitle,
      isLargeHeader: true,
      animateChildren: false,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: colorScheme.onSurface.withValues(alpha: 0.05),
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Without CleVer
                          Expanded(
                            child: _ComparisonBar(
                              label: l10n.onboardingComparisonLabelLeft,
                              value: l10n.onboardingComparisonValueLeft,
                              percent: 0.2, // 20%
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.3,
                              ),
                              delay: 400.ms,
                            ),
                          ),
                          const SizedBox(width: 24),
                          // With CleVer
                          Expanded(
                            child: _ComparisonBar(
                              label: l10n.onboardingComparisonLabelRight,
                              value: l10n.onboardingComparisonValueRight,
                              percent: 1.0, // 2X / Full
                              isPrimary: true,
                              delay: 700.ms,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(
                    begin: const Offset(0.98, 0.98),
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 24),
              Text(
                l10n.onboardingComparisonFooter,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(delay: 1000.ms),
            ],
          ),
        ),
      ],
      footer: SizedBox(
        width: double.infinity,
        child: GradientButton(text: l10n.showMeTheWay, onPressed: onNext),
      ),
    );
  }
}

class _ComparisonBar extends StatelessWidget {
  final String label;
  final String value;
  final double percent;
  final Color? color;
  final bool isPrimary;
  final Duration delay;

  const _ComparisonBar({
    required this.label,
    required this.value,
    required this.percent,
    this.color,
    this.isPrimary = false,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelBold.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ).animate().fadeIn(delay: delay - 100.ms),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // The Bar
              FractionallySizedBox(
                    heightFactor: percent,
                    widthFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: isPrimary
                            ? LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.tertiary,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              )
                            : null,
                        color: !isPrimary ? color : null,
                      ),
                    ),
                  )
                  .animate()
                  .scaleY(
                    duration: 1200.ms,
                    curve: Curves.easeOutQuart,
                    alignment: Alignment.bottomCenter,
                    begin: 0,
                    delay: delay,
                  )
                  .fadeIn(delay: delay + 100.ms),

              // The Value
              Positioned(
                    bottom: 16,
                    child: Text(
                      value,
                      style:
                          (isPrimary
                                  ? AppTextStyles.h3
                                  : AppTextStyles.bodyLarge)
                              .copyWith(
                                fontWeight: FontWeight.w900,
                                color: isPrimary
                                    ? Colors.white
                                    : colorScheme.onSurface,
                              ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: delay + 800.ms)
                  .moveY(
                    begin: 10,
                    end: 0,
                    delay: delay + 800.ms,
                    duration: 400.ms,
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
