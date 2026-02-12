import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import
import '../../legal/pages/legal_page.dart';
import 'onboarding_legal_modal.dart';
import '../../common/widgets/spinning_text_loader.dart'; // Import

class OnboardingNavigationBar extends StatelessWidget {
  final int currentPage;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final bool isLastPage;
  final bool isLoading; // New

  const OnboardingNavigationBar({
    super.key,
    required this.currentPage,
    required this.onNext,
    required this.onBack,
    this.isLastPage = false,
    this.isLoading = false, // Default false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          // Terms & Conditions Text (Only on Final Step)
          if (isLastPage) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: RichText(
                textAlign: TextAlign.center,
                
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.white38, fontFamily: 'Outfit'),
                  children: [
                    const TextSpan(
                      text: 'Dengan menekan "MULAI SEKARANG", kamu setuju dengan ',
                    ),
                    TextSpan(
                      text: 'Syarat & Ketentuan',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          OnboardingLegalModal.show(context, title: 'Terms of Service', content: kTermsOfService);
                        },
                    ),
                    const TextSpan(text: ' dan '),
                    TextSpan(
                      text: 'Kebijakan Privasi',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          OnboardingLegalModal.show(context, title: 'Privacy Policy', content: kPrivacyPolicy);
                        },
                    ),
                    const TextSpan(text: ' kami.'),
                  ],
                ),
              ),
            ),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Softer corners
                ),
              ),
              child: isLoading 
                ? SizedBox(
                    height: 20,
                     child: SpinningTextLoader(
                      texts: const ['Finalizing...', 'Saving Profile...', 'Ready!'],
                      style: GoogleFonts.outfit(
                         color: Colors.black, 
                         fontWeight: FontWeight.w900,
                         fontSize: 16,
                         letterSpacing: 1.0,
                      ),
                      interval: const Duration(milliseconds: 800),
                    ),
                  ) 
                : Text(
                  isLastPage ? 'MULAI SEKARANG' : 'NEXT STEP',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 1.0,
                  ),
                ),
            ),
          ),

          if (currentPage > 0) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onBack,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white54,
              ),
              child: const Text('Back', style: TextStyle(fontSize: 14)),
            ),
          ] else ...[
            const SizedBox(height: 24), // Spacer to keep balance if no back button
          ],
        ],
      ),
    );
  }
}
