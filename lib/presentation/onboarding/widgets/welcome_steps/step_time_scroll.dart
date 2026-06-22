import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../onboarding_step_screen.dart';

/// A single scrollable time option with a numeric value and localized label.
class TimeOption {
  final int hours;
  final String Function(AppLocalizations) labelBuilder;

  const TimeOption({required this.hours, required this.labelBuilder});
}

/// Cal AI-style scroll wheel picker for "time spent making a CV".
///
/// Displays a large label at the top and a 3D-perspective ListWheelScrollView
/// with a highlight band — matching the cling number scroll aesthetic.
class StepTimeScroll extends StatefulWidget {
  final String title;
  final List<TimeOption> options;
  final int? selectedHours;
  final Function(int hours) onSelect;
  final VoidCallback onNext;

  const StepTimeScroll({
    super.key,
    required this.title,
    required this.options,
    required this.selectedHours,
    required this.onSelect,
    required this.onNext,
  });

  @override
  State<StepTimeScroll> createState() => _StepTimeScrollState();
}

class _StepTimeScrollState extends State<StepTimeScroll> {
  late final FixedExtentScrollController _scrollController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedHours != null
        ? widget.options
              .indexWhere((o) => o.hours == widget.selectedHours)
              .clamp(0, widget.options.length - 1)
        : 0;
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedIndex,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final selectedOption = widget.options[_selectedIndex];

    return OnboardingStepScreen(
      title: widget.title,
      children: [
        // Large value display
        Center(
          child: Text(
            selectedOption.labelBuilder(l10n),
            style: AppTextStyles.h2.copyWith(
              color: colorScheme.onSurface,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1.0,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Scroll wheel
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Stack(
              children: [
                // Selection highlight band
                Center(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // Wheel
                ListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  itemExtent: 48,
                  diameterRatio: 3,
                  perspective: 0.002,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() => _selectedIndex = index);
                    widget.onSelect(widget.options[index].hours);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: widget.options.length,
                    builder: (context, index) {
                      final option = widget.options[index];
                      final isSelected = index == _selectedIndex;
                      return Center(
                        child: Text(
                          option.labelBuilder(l10n),
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: isSelected
                                ? colorScheme.onSurface
                                : colorScheme.onSurface.withValues(alpha: 0.25),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            fontSize: isSelected ? 18 : 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      footer: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.selectedHours != null ? widget.onNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.onSurface,
            foregroundColor: colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            disabledBackgroundColor: colorScheme.onSurface.withValues(
              alpha: 0.1,
            ),
            disabledForegroundColor: colorScheme.onSurface.withValues(
              alpha: 0.3,
            ),
          ),
          child: Text(
            l10n.next.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
