import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

enum CleverNavTone { midnight, orange, cream }

class CleverNavActionBar extends StatelessWidget {
  const CleverNavActionBar({
    super.key,
    required this.onNext,
    this.onBack,
    this.backLabel,
    this.nextLabel,
    this.tone = CleverNavTone.midnight,
  });

  final VoidCallback onNext;

  /// When null, the back control is omitted entirely (e.g. the header step,
  /// where closing the sheet is the way back).
  final VoidCallback? onBack;
  final String? backLabel;
  final String? nextLabel;
  final CleverNavTone tone;

  @override
  Widget build(BuildContext context) {
    final (backFg, nextFill, nextFg) = switch (tone) {
      CleverNavTone.midnight => (
        CleverColors.textPrimary,
        CleverColors.surfaceInverse,
        CleverColors.bgCanvas,
      ),
      CleverNavTone.orange => (
        CleverColors.textAccent,
        CleverColors.bgAction,
        CleverColors.textOnDark,
      ),
      CleverNavTone.cream => (
        CleverColors.textOnDark,
        CleverColors.bgCanvas,
        CleverColors.textPrimary,
      ),
    };
    final iconNext = nextLabel == null;
    final nextButton = ElevatedButton(
      onPressed: onNext,
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: WidgetStatePropertyAll(nextFg),
        backgroundColor: WidgetStatePropertyAll(nextFill),
        overlayColor: WidgetStatePropertyAll(
          iconNext
              ? CleverColors.textOnDark.withValues(alpha: 0.15)
              : CleverColors.surfaceInverse.withValues(alpha: 0.12),
        ),
        minimumSize: WidgetStatePropertyAll(
          iconNext ? const Size(58, 58) : const Size(92, 42),
        ),
        padding: WidgetStatePropertyAll(
          iconNext
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: CleverSpacing.space24),
        ),
        textStyle: WidgetStatePropertyAll(CleverTypography.h4),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              iconNext ? CleverRadius.field : CleverRadius.button,
            ),
          ),
        ),
      ),
      child: iconNext
          ? const Icon(Icons.arrow_outward, size: 30)
          : Text(nextLabel!),
    );

    if (onBack == null) {
      return nextButton;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onBack,
          style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: WidgetStatePropertyAll(backFg),
            overlayColor: WidgetStatePropertyAll(
              CleverColors.surfaceInverse.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back, size: 24),
              if (backLabel != null) ...[
                const SizedBox(width: 7),
                Text(backLabel!, style: CleverTypography.body),
              ],
            ],
          ),
        ),
        nextButton,
      ],
    );
  }
}
