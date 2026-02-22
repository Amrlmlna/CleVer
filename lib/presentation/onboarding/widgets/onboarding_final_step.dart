import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class OnboardingFinalStep extends StatelessWidget {
  const OnboardingFinalStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 64),
            Text(
              AppLocalizations.of(context)!.onboardingFinalMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
