import 'package:flutter/material.dart';
import '../../../../core/constants/universities_data.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class UniversityPicker extends StatefulWidget {
  final TextEditingController controller;
  final bool isDark;

  const UniversityPicker({
    super.key, 
    required this.controller, 
    this.isDark = false
  });

  @override
  State<UniversityPicker> createState() => _UniversityPickerState();
}

class _UniversityPickerState extends State<UniversityPicker> {
  @override
  Widget build(BuildContext context) {
    final effectiveIsDark = widget.isDark || Theme.of(context).brightness == Brightness.dark;
    final fillColor = effectiveIsDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100];
    final textColor = effectiveIsDark ? Colors.white : Colors.black87;
    final labelColor = effectiveIsDark ? Colors.white70 : Colors.black54;
    final borderColor = effectiveIsDark ? Colors.white24 : Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') return const Iterable<String>.empty();
                return kUniversities.where((option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (selection) {
                widget.controller.text = selection;
              },
              
              fieldViewBuilder: (context, fieldTextEditingController, focusNode, onFieldSubmitted) {
                if (widget.controller.text.isNotEmpty && fieldTextEditingController.text.isEmpty) {
                   fieldTextEditingController.text = widget.controller.text;
                }
                
                return TextFormField(
                  controller: fieldTextEditingController,
                  focusNode: focusNode,
                  style: TextStyle(color: textColor),
                  cursorColor: effectiveIsDark ? Colors.white : Colors.black,
                  validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.schoolLabel,
                    labelStyle: TextStyle(color: labelColor),
                    hintText: AppLocalizations.of(context)!.schoolHint,
                    hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.5)),
                    prefixIcon: Icon(Icons.school, color: labelColor),
                    filled: true,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: borderColor != Colors.transparent ? BorderSide(color: borderColor) : BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12),
                       borderSide: borderColor != Colors.transparent ? BorderSide(color: borderColor) : BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12),
                       borderSide: BorderSide(color: effectiveIsDark ? Colors.white54 : Colors.black, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  onChanged: (val) {
                    widget.controller.text = val;
                  },
                );
              },
              
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    color: effectiveIsDark ? const Color(0xFF1E1E1E) : Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    child: Container(
                      width: constraints.maxWidth,
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            title: Text(
                              option, 
                              style: TextStyle(color: textColor, fontSize: 13),
                            ),
                            leading: Icon(Icons.school_outlined, size: 16, color: labelColor),
                            onTap: () => onSelected(option),
                            hoverColor: effectiveIsDark ? Colors.white10 : Colors.grey[100],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        ),
      ],
    );
  }
}
