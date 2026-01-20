import 'package:flutter/material.dart';

class OnboardingFinalStep extends StatelessWidget {
  const OnboardingFinalStep({super.key});

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
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          ),
          const SizedBox(height: 48),
          const Text(
            'Selesai!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Master Profile kamu udah tersimpan. Nanti bisa dipakai buat generate CV otomatis.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Dengan menekan "Mulai Sekarang", kamu setuju dengan Syarat & Ketentuan kami.',
             textAlign: TextAlign.center,
             style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
