import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_text_styles.dart';

class OnboardingTweetCard extends StatelessWidget {
  final String handle;
  final String content;
  final int likes;
  final int retweets;
  final Duration delay;

  const OnboardingTweetCard({
    super.key,
    required this.handle,
    required this.content,
    this.likes = 124,
    this.retweets = 42,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          handle,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Just now',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.9),
                  height: 1.4,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStat(
                    Icons.chat_bubble_outline_rounded,
                    '12',
                    colorScheme,
                  ),
                  const SizedBox(width: 24),
                  _buildStat(
                    Icons.repeat_rounded,
                    retweets.toString(),
                    colorScheme,
                  ),
                  const SizedBox(width: 24),
                  _buildStat(
                    Icons.favorite_border_rounded,
                    likes.toString(),
                    colorScheme,
                  ),
                  const Spacer(),
                  _buildStat(Icons.share_outlined, '', colorScheme),
                ],
              ),
            ],
          ),
        )
        .animate(delay: delay)
        .fadeIn(duration: 600.ms, curve: Curves.easeOutCubic)
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildStat(IconData icon, String value, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        if (value.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }
}
