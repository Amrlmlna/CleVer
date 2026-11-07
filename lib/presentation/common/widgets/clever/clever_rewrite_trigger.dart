import 'package:flutter/material.dart';
import 'package:flutter_micro_interactions/flutter_micro_interactions.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

/// The AI-rewrite action on every form sheet: a small orange pill, press
/// feedback from the micro-interactions kit, and NO sparkle icon.
class CleverRewriteTrigger extends StatelessWidget {
  const CleverRewriteTrigger({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapFeedback.scale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(CleverRadius.field),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CleverSpacing.space12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: CleverColors.bgAction,
            borderRadius: BorderRadius.circular(CleverRadius.field),
          ),
          child: Text(
            label,
            style: CleverTypography.bodySm.copyWith(
              color: CleverColors.textOnDark,
            ),
          ),
        ),
      ),
    );
  }
}

/// Rewrite loading: the AI is "writing" — typewriter effect from the
/// micro-interactions kit replaces the old shimmering cycling text.
class CleverRewriteLoading extends StatelessWidget {
  const CleverRewriteLoading({
    super.key,
    required this.phrases,
  });

  final List<String> phrases;

  @override
  Widget build(BuildContext context) {
    return TypewriterText(
      strings: phrases,
      loop: true,
      style: CleverTypography.bodySm.copyWith(
        color: CleverColors.textPrimary,
      ),
      cursorColor: CleverColors.bgAction,
    );
  }
}
