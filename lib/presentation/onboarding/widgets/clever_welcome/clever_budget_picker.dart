import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_typography.dart';

class CleverBudgetPicker extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 56,
        perspective: 0.0015,
        diameterRatio: 2.2,
        physics: const FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(initialItem: selectedIndex),
        onSelectedItemChanged: onSelected,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: values.length,
          builder: (context, index) {
            final distance = (index - selectedIndex).abs();
            final style = distance == 0
                ? CleverTypography.h1.copyWith(color: CleverColors.textPrimary)
                : CleverTypography.h3.copyWith(
                    color: CleverColors.textPrimary.withValues(
                      alpha: distance == 1 ? 0.55 : 0.42,
                    ),
                  );
            return Center(child: Text(values[index], style: style));
          },
        ),
      ),
    );
  }
}
