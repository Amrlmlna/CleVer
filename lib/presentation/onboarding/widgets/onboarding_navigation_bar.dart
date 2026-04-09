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
            const SizedBox(height: 8),
            Row(
              children: [
                // ← Back: outlined box icon button — no label needed
                if (currentPage > 0)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onBack,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                const Spacer(),

                // Skip: ghost text link — clearly tertiary
                if (isSkippable && onSkip != null)
                  TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.skipForNow,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
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
