import 'package:flutter/material.dart';
import '../../../../core/constants/universities_data.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class UniversityPicker extends StatefulWidget {
  final TextEditingController controller;

  const UniversityPicker({
    super.key,
    required this.controller,
  });

  @override
  State<UniversityPicker> createState() => _UniversityPickerState();
}

class _UniversityPickerState extends State<UniversityPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<String>(
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

                    return TextFormField(
                      controller: fieldTextEditingController,
                      focusNode: focusNode,
                      style: Theme.of(context).textTheme.bodyLarge,
                      validator: (v) => v!.isEmpty
                          ? AppLocalizations.of(context)!.requiredField
                          : null,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.schoolLabel,
                        hintText: AppLocalizations.of(context)!.schoolHint,
                        prefixIcon: const Icon(Icons.school),
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
                    color: Theme.of(context).colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
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
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            leading: Icon(
                              Icons.school_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            onTap: () => onSelected(option),
                            hoverColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
