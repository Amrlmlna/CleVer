import 'package:flutter/material.dart';

class OnboardingWelcomeStep extends StatelessWidget {
  const OnboardingWelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.rocket_launch, size: 80, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 48),
          const Text(
            'Jangan Bikin CV Pasaran.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Isi data sekali, pakai berkali-kali.\nSemua CV otomatis terisi dari data kamu.\nFokus ke karier, bukan ngetik ulang.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
