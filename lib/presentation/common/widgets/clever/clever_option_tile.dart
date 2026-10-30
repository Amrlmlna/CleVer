import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

class CleverOptionTile extends StatelessWidget {
  const CleverOptionTile({
    super.key,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final (fill, foreground, iconColor) = selected
        ? (
            CleverColors.surfaceInverse,
            CleverColors.textOnDark,
            CleverColors.bgCanvas,
          )
        : (
            CleverColors.surfaceSelected,
            CleverColors.textPrimary,
            CleverColors.surfaceInverse,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(CleverRadius.button),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        color: fill,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 34,
                top: 17,
                bottom: 17,
                right: 24,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: CleverTypography.h4.copyWith(color: foreground),
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: CleverSpacing.space12),
                    Icon(trailingIcon, size: 24, color: iconColor),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
