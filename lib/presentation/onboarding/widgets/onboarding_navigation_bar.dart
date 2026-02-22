import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../legal/pages/legal_page.dart';
import 'onboarding_legal_modal.dart';
import '../../common/widgets/spinning_text_loader.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class OnboardingNavigationBar extends StatelessWidget {
  final int currentPage;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final bool isLastPage;
  final bool isLoading;
  final bool isSkippable;
  final VoidCallback? onSkip;

  const OnboardingNavigationBar({
    super.key,
    required this.currentPage,
    required this.onNext,
    required this.onBack,
    this.isLastPage = false,
    this.isLoading = false,
    this.isSkippable = false,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          if (isLastPage) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: RichText(
                textAlign: TextAlign.center,
                
                  text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.white38, fontFamily: 'Outfit'),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.termsAgreePrefix,
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.termsOfService,
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
                    TextSpan(text: AppLocalizations.of(context)!.and),
                    TextSpan(
                      text: AppLocalizations.of(context)!.privacyPolicy,
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
                    TextSpan(text: AppLocalizations.of(context)!.termsAgreeSuffix),
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
                backgroundColor: isLoading ? Colors.black : Colors.white,
                foregroundColor: isLoading ? Colors.white : Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading 
                ? SizedBox(
                    height: 20,
                     child: SpinningTextLoader(
                      texts: [
                        AppLocalizations.of(context)!.finalizing,
                        AppLocalizations.of(context)!.savingProfile,
                        AppLocalizations.of(context)!.ready
                      ],
                      style: GoogleFonts.outfit(
                         color: Colors.white,
                         fontWeight: FontWeight.w900,
                         fontSize: 16,
                         letterSpacing: 1.0,
                      ),
                      interval: const Duration(milliseconds: 800),
                    ),
                  ) 
                : Text(
                  isLastPage ? AppLocalizations.of(context)!.startNow : AppLocalizations.of(context)!.nextStep,
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
            if (isSkippable && onSkip != null) ...[
              TextButton(
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white38,
                ),
                child: Text(AppLocalizations.of(context)!.skipForNow, style: const TextStyle(fontSize: 13)),
              ),
            ],
            TextButton(
              onPressed: onBack,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white54,
              ),
              child: Text(AppLocalizations.of(context)!.back, style: const TextStyle(fontSize: 14)),
            ),
          ] else ...[
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
