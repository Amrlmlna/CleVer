import 'package:flutter/material.dart';
import 'package:cv_master/core/constants/regions_data.dart';

class LocationPicker extends StatefulWidget {
  final TextEditingController controller;
  final bool isDark;

  const LocationPicker({super.key, required this.controller, required this.isDark});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  // We use local data now: kIndonesianRegions

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark = widget.isDark || Theme.of(context).brightness == Brightness.dark;
    final fillColor = effectiveIsDark ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = effectiveIsDark ? Colors.white : Colors.black87;
    // ensure labelColor is not null for older flutter versions
    final Color labelColor = effectiveIsDark ? Colors.grey[400]! : Colors.grey[600]!; 
    final borderColor = effectiveIsDark ? Colors.transparent : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<Map<String, String>>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') return const Iterable<Map<String, String>>.empty();
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
              
              // Custom Input Field
              fieldViewBuilder: (context, fieldTextEditingController, focusNode, onFieldSubmitted) {
                // Initial sync if controller has value and field is empty
                if (widget.controller.text.isNotEmpty && fieldTextEditingController.text.isEmpty) {
                   fieldTextEditingController.text = widget.controller.text;
                }
                
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: focusNode,
                  style: TextStyle(color: textColor),
                  cursorColor: effectiveIsDark ? Colors.white : Colors.black,
                  decoration: InputDecoration(
                    labelText: 'Lokasi (Cari Kota/Kabupaten)',
                    labelStyle: TextStyle(color: labelColor),
                    hintText: 'Cth: Palu -> Sulawesi Tengah, Kota Palu',
                    hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.5)),
                    prefixIcon: Icon(Icons.location_on, color: labelColor),
                    filled: true,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12),
                       borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12),
                       borderSide: BorderSide(color: effectiveIsDark ? Colors.white54 : Colors.black, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  onChanged: (val) {
                    // Update controller on raw input to allow manual overrides or partials
                    widget.controller.text = val;
                  },
                );
              },
              
              // Custom Options List
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
                              option['label']!,
                              style: TextStyle(color: textColor, fontSize: 13),
                            ),
                            leading: Icon(Icons.place, size: 16, color: labelColor),
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
