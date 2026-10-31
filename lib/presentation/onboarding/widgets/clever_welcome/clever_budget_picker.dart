import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';

/// Budget wheel picker following the previous onboarding's scroll pattern:
/// large selected value on top, ListWheelScrollView with a highlight band,
/// faded neighbours.
class CleverBudgetPicker extends StatefulWidget {
  const CleverBudgetPicker({
    super.key,
    required this.values,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> values;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<CleverBudgetPicker> createState() => _CleverBudgetPickerState();
}

class _CleverBudgetPickerState extends State<CleverBudgetPicker> {
  late final FixedExtentScrollController _controller =
      FixedExtentScrollController(initialItem: widget.selectedIndex);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            widget.values[widget.selectedIndex],
            style: CleverTypography.h1.copyWith(
              color: CleverColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: CleverSpacing.space32),
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: CleverColors.surfaceSelected,
                    borderRadius: BorderRadius.circular(CleverRadius.field),
                  ),
                ),
              ),
              ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 48,
                diameterRatio: 3,
                perspective: 0.002,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: widget.onSelected,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: widget.values.length,
                  builder: (context, index) {
                    final isSelected = index == widget.selectedIndex;
                    return Center(
                      child: Text(
                        widget.values[index],
                        style: isSelected
                            ? CleverTypography.bodyStrong.copyWith(
                                color: CleverColors.textPrimary,
                              )
                            : CleverTypography.body.copyWith(
                                color: CleverColors.textPrimary.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
