import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../onboarding_diagnosis_screen.dart';

import 'package:clever/l10n/generated/app_localizations.dart';

class StepDiagnosis extends StatelessWidget {
  final String burnoutCause;
  final String timeSpent;
  final VoidCallback onNext;

  const StepDiagnosis({
    super.key,
    required this.burnoutCause,
    required this.timeSpent,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      key: const ValueKey('step4'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OnboardingDiagnosisScreen(
          burnoutCause: burnoutCause,
          timeSpent: timeSpent,
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.onboardingViewSolution,
                style: AppTextStyles.button,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
