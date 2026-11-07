import 'package:flutter/material.dart';
import 'package:flutter_micro_interactions/flutter_micro_interactions.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

enum CleverButtonStyle { inverse, action, canvas }

class CleverButton extends StatefulWidget {
  const CleverButton({
    super.key,
    required this.label,
    this.onTap,
    this.style = CleverButtonStyle.inverse,
    this.height = CleverSizes.actionBar,
    this.labelStyle,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onTap;
  final CleverButtonStyle style;
  final double height;
  final TextStyle? labelStyle;

  /// While true the label swaps for a spinner (via ButtonStates) and taps
  /// are disabled — for save/submit actions. Backwards compatible: every
  /// existing call site stays idle by default.
  final bool busy;

  @override
  State<CleverButton> createState() => _CleverButtonState();
}

class _CleverButtonState extends State<CleverButton> {
  late final ButtonStateController _states = ButtonStateController(
    widget.busy ? MicroButtonState.loading : MicroButtonState.idle,
  );

  @override
  void didUpdateWidget(CleverButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.busy != oldWidget.busy) {
      widget.busy ? _states.setLoading() : _states.setIdle();
    }
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (fill, foreground) = switch (widget.style) {
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
    final overlay = widget.style == CleverButtonStyle.inverse
        ? CleverColors.textOnDark.withValues(alpha: 0.15)
        : CleverColors.surfaceInverse.withValues(alpha: 0.12);

    return SizedBox(
      width: double.infinity,
      child: ButtonStates(
        controller: _states,
        duration: const Duration(milliseconds: 200),
        loadingBuilder: (_) => Center(
          child: SizedBox.square(
            dimension: widget.height * 0.44,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              strokeCap: StrokeCap.round,
              color: foreground,
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: widget.busy ? null : widget.onTap,
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: WidgetStatePropertyAll(Size.fromHeight(widget.height)),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: CleverSpacing.space24),
            ),
            textStyle: WidgetStatePropertyAll(
              widget.labelStyle ?? CleverTypography.h4,
            ),
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
          child: Text(widget.label),
        ),
      ),
    );
  }
}
