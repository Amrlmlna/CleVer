import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

class CleverGoogleButton extends StatelessWidget {
  const CleverGoogleButton({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const WidgetStatePropertyAll(
          Size.fromHeight(CleverSizes.actionBar),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 29),
        ),
        textStyle: WidgetStatePropertyAll(CleverTypography.h4),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CleverRadius.field),
          ),
        ),
        side: const WidgetStatePropertyAll(
          BorderSide(
            color: CleverColors.bgCanvas,
            width: CleverStrokes.hairline,
          ),
        ),
        overlayColor: WidgetStatePropertyAll(
          CleverColors.textOnDark.withValues(alpha: 0.15),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? CleverColors.stateDisabled
              : CleverColors.surfaceInverse,
        ),
        foregroundColor: const WidgetStatePropertyAll(CleverColors.textOnDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/google_logo.png', width: 25, height: 26),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
