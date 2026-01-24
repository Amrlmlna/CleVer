import 'package:flutter/material.dart';

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
            // Success Illustration with Fade/Depth Effect
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  'assets/images/onboarding_complete.png',
                  height: 250, 
                  fit: BoxFit.contain,
                ),
                // Gradient Overlay for "Depth" / Fade into background
                Container(
                  height: 80, // Height of the fade
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
            
            const Text(
              'Master Profile aman. Sekarang tinggal sat-set bikin CV.',
              textAlign: TextAlign.center,
              style: TextStyle(
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
