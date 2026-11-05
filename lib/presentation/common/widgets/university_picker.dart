import 'package:flutter/material.dart';
import '../../../../core/constants/universities_data.dart';
import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import 'clever/clever_text_field.dart';

/// University autocomplete styled on the Clever design system: the field is a
/// standard [CleverTextField] (filled surface, orange focus ring) and the
/// suggestion overlay is a cream Clever surface — the legacy theme-styled
/// TextFormField looked foreign inside the education sheet. The selection
/// machinery (kUniversities filtering, controller/focus wiring) is unchanged.
class UniversityPicker extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const UniversityPicker({super.key, required this.controller, this.focusNode});

  @override
  State<UniversityPicker> createState() => _UniversityPickerState();
}

class _UniversityPickerState extends State<UniversityPicker> {
  FocusNode? _localFocusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_localFocusNode ??= FocusNode());

  @override
  void dispose() {
    _localFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<String>(
          focusNode: _effectiveFocusNode,
          textEditingController: widget.controller,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '')
              return const Iterable<String>.empty();
            return kUniversities.where((option) {
              return option.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              );
            });
          },
          onSelected: (selection) {
            widget.controller.text = selection;
          },

          fieldViewBuilder:
              (
                context,
                fieldTextEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                if (widget.controller.text.isNotEmpty &&
                    fieldTextEditingController.text.isEmpty) {
                  fieldTextEditingController.text = widget.controller.text;
                }

                return CleverTextField(
                  controller: fieldTextEditingController,
                  focusNode: focusNode,
                  hintText: l10n.schoolHint,
                  surface: CleverFieldSurface.filled,
                  prefixIcon: Icons.school_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
                  onChanged: (val) {
                    widget.controller.text = val;
                  },
                );
              },

          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: CleverSpacing.space8),
                child: Material(
                  color: CleverColors.bgCanvas,
                  borderRadius: BorderRadius.circular(CleverRadius.field),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: constraints.maxWidth,
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          title: Text(
                            option,
                            style: CleverTypography.body.copyWith(
                              color: CleverColors.textPrimary,
                            ),
                          ),
                          leading: const Icon(
                            Icons.school_outlined,
                            size: 16,
                            color: CleverColors.bgAction,
                          ),
                          onTap: () => onSelected(option),
                          hoverColor: CleverColors.surfaceField,
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
