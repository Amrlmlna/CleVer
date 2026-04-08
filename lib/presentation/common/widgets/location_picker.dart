import 'package:flutter/material.dart';
import 'package:clever/core/constants/regions_data.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class LocationPicker extends StatefulWidget {
  final TextEditingController controller;

  const LocationPicker({
    super.key,
    required this.controller,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<Map<String, String>>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '')
                  return const Iterable<Map<String, String>>.empty();
                return kIndonesianRegions.where((option) {
                  final label = option['label']!.toLowerCase();
                  final input = textEditingValue.text.toLowerCase();
                  return label.contains(input);
                });
              },
              displayStringForOption: (option) => option['label']!,
              onSelected: (selection) {
                widget.controller.text = selection['label']!;
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

                    return TextField(
                      controller: fieldTextEditingController,
                      focusNode: focusNode,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.locationLabel,
                        hintText: AppLocalizations.of(context)!.locationHint,
                        prefixIcon: const Icon(Icons.location_on),
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
                              option['label']!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            leading: Icon(
                              Icons.place,
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
