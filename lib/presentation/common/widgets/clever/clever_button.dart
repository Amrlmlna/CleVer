import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

enum CleverButtonStyle { inverse, action, canvas }

class CleverButton extends StatelessWidget {
  const CleverButton({
    super.key,
    required this.label,
    this.onTap,
    this.style = CleverButtonStyle.inverse,
    this.height = CleverSizes.actionBar,
    this.labelStyle,
  });

  final String label;
  final VoidCallback? onTap;
  final CleverButtonStyle style;
  final double height;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final (fill, foreground) = switch (style) {
      CleverButtonStyle.inverse => (
        CleverColors.surfaceInverse,
        CleverColors.textOnDark,
      ),
      CleverButtonStyle.action => (
        CleverColors.bgAction,
        CleverColors.textOnDark,
      ),
      CleverButtonStyle.canvas => (
        CleverColors.bgCanvas,
        CleverColors.textPrimary,
      ),
    };
    final overlay = style == CleverButtonStyle.inverse
        ? CleverColors.textOnDark.withValues(alpha: 0.15)
        : CleverColors.surfaceInverse.withValues(alpha: 0.12);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStatePropertyAll(Size.fromHeight(height)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: CleverSpacing.space24),
          ),
          textStyle: WidgetStatePropertyAll(labelStyle ?? CleverTypography.h4),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(CleverRadius.button),
            ),
          ),
          overlayColor: WidgetStatePropertyAll(overlay),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? CleverColors.stateDisabled
                : fill,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? CleverColors.textOnDark
                : foreground,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
