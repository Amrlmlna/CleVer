import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../onboarding_step_screen.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class SelectionOption {
  final String text;
  final IconData icon;

  SelectionOption({required this.text, required this.icon});
}

class StepSelectionList extends StatelessWidget {
  final String title;
  final List<SelectionOption> options;
  final String? selectedOption;
  final Function(String) onSelect;
  final VoidCallback onNext;

  const StepSelectionList({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return OnboardingStepScreen(
      title: title,
      children: options
          .map(
            (opt) => OnboardingSelectionCard(
              text: opt.text,
              icon: opt.icon,
              isSelected: selectedOption == opt.text,
              onTap: () => onSelect(opt.text),
            ),
          )
          .toList(),
      footer:
          Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: selectedOption != null ? onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(l10n.next, style: AppTextStyles.button),
                ),
              )
              .animate(target: selectedOption != null ? 1 : 0)
              .fadeIn()
              .scale(begin: const Offset(0.95, 0.95)),
    );
  }
}
