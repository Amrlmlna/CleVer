import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.termsAgreePrefix,
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.termsOfService,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          OnboardingLegalModal.show(
                            context,
                            title: 'Terms of Service',
                            content: kTermsOfService,
                          );
                        },
                    ),
                    TextSpan(text: AppLocalizations.of(context)!.and),
                    TextSpan(
                      text: AppLocalizations.of(context)!.privacyPolicy,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          OnboardingLegalModal.show(
                            context,
                            title: 'Privacy Policy',
                            content: kPrivacyPolicy,
                          );
                        },
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.termsAgreeSuffix,
                    ),
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
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
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
                          AppLocalizations.of(context)!.ready,
                        ],
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                        interval: const Duration(milliseconds: 800),
                      ),
                    )
                  : Text(
                      isLastPage
                          ? AppLocalizations.of(context)!.startNow
                          : AppLocalizations.of(context)!.nextStep,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: colorScheme.onPrimary,
                      ),
                    ),
            ),
          ),

          if (currentPage > 0 || isSkippable) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentPage > 0)
                  TextButton(
                    onPressed: onBack,
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.back,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                if (currentPage > 0 && isSkippable && onSkip != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 1,
                      height: 12,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                if (isSkippable && onSkip != null)
                  TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.skipForNow,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
