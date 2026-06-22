import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }
}
