import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

class CleverDivider extends StatelessWidget {
  const CleverDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final line = CleverColors.surfaceInverse.withValues(alpha: 0.18);

    return Row(
      children: [
        Expanded(child: Container(height: 1, color: line)),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CleverSpacing.space16,
          ),
          child: Text(
            label,
            style: CleverTypography.bodyStrong.copyWith(
              color: CleverColors.textPrimary.withValues(alpha: 0.65),
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: line)),
      ],
    );
  }
}
