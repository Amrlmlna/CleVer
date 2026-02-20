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
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  'assets/images/onboarding_complete.png',
                  height: 250, 
                  fit: BoxFit.contain,
                ),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF1E1E1E).withValues(alpha: 0.0),
                        const Color(0xFF1E1E1E), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
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
