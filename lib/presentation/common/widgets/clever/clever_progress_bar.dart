import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

class CleverProgressBar extends StatelessWidget {
  const CleverProgressBar({
    super.key,
    required this.index,
    required this.total,
  });

  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fraction = total <= 0 ? 0.0 : (index / total).clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 4,
              color: CleverColors.surfaceSelected,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: fraction,
                child: Container(
                  height: double.infinity,
                  color: CleverColors.surfaceInverse,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: CleverSpacing.space8),
        Text(
          '$index/$total',
          style: CleverTypography.label.copyWith(
            color: CleverColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
