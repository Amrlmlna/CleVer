import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32), // High rounded corners
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFE0E0E0), // Subtle silver gradient
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
           // Optional: Subtle grain or noise if we could, but clean is better
           Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badge / Icon
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'AI POWERED',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Minimalist Large Typography
                const Text(
                  'Buat CV\nPertama Kamu.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 42, // Very Large
                    fontWeight: FontWeight.w600, // Semi Bold, clean
                    fontFamily: 'Outfit',
                    height: 1.0, 
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Full Width Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => context.push('/create/job-input'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100), // Pill shape
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    child: const Text(
                      'Mulai Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
