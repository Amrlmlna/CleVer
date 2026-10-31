import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

enum CleverFieldSurface { outline, filled, filledOnAction }

class CleverTextField extends StatefulWidget {
  const CleverTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.surface = CleverFieldSurface.outline,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.prefixIcon,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.enabled = true,
  });

  final String hintText;
  final TextEditingController? controller;
  final CleverFieldSurface surface;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  State<CleverTextField> createState() => _CleverTextFieldState();
}

class _CleverTextFieldState extends State<CleverTextField> {
  late bool _obscured = widget.obscureText;

  @override
  void didUpdateWidget(CleverTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscured = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(
      widget.surface == CleverFieldSurface.outline
          ? CleverRadius.field
          : CleverRadius.button,
    );
    InputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color, width: width),
    );

    final fill = switch (widget.surface) {
      CleverFieldSurface.outline => CleverColors.bgCanvas,
      CleverFieldSurface.filled => CleverColors.surfaceField,
      CleverFieldSurface.filledOnAction => CleverColors.surfaceFieldOnAction,
    };
    final hintColor = switch (widget.surface) {
      CleverFieldSurface.outline => CleverColors.textSecondary.withValues(
        alpha: 0.55,
      ),
      CleverFieldSurface.filled => CleverColors.textPrimary.withValues(
        alpha: 0.6,
      ),
      CleverFieldSurface.filledOnAction => CleverColors.textOnDark.withValues(
        alpha: 0.6,
      ),
    };
    final onAction = widget.surface == CleverFieldSurface.filledOnAction;
    final controlColor = onAction
        ? CleverColors.textOnDark
        : CleverColors.surfaceInverse;
    final enabledBorder = widget.surface == CleverFieldSurface.outline
        ? border(CleverColors.surfaceInverse, CleverStrokes.hairline)
        : border(Colors.transparent, CleverStrokes.hairline);

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
      obscureText: _obscured,
      cursorColor: controlColor,
      onChanged: widget.onChanged,
      style: CleverTypography.body.copyWith(
        color: onAction ? CleverColors.textOnDark : CleverColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: CleverTypography.body.copyWith(color: hintColor),
        errorStyle: CleverTypography.caption.copyWith(
          color: CleverColors.textDanger,
        ),
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, size: 22, color: controlColor),
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () => setState(() => _obscured = !_obscured),
                icon: Icon(
                  _obscured ? Icons.visibility : Icons.visibility_off,
                  size: 20,
                  color: controlColor,
                ),
              )
            : null,
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 16,
        ),
        border: enabledBorder,
        enabledBorder: enabledBorder,
        focusedBorder: border(CleverColors.bgAction, CleverStrokes.focus),
        errorBorder: border(CleverColors.textDanger, CleverStrokes.focus),
        focusedErrorBorder: border(
          CleverColors.textDanger,
          CleverStrokes.focus,
        ),
      ),
    );
  }
}
