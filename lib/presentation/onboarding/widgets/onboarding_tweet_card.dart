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

    return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          handle,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Just now'.toUpperCase(),
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz, color: colorScheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 20),
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
                  Icon(
                    Icons.share_outlined,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
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
