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
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  // Soft helper line
                  Text(
                    AppLocalizations.of(context)!.termsAgreePrefix,
                    textAlign: TextAlign.center,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Pill chip row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LegalChip(
                        label: AppLocalizations.of(context)!.termsOfService,
                        onTap: () => OnboardingLegalModal.show(
                          context,
                          title: 'Terms of Service',
                          content: kTermsOfService,
                        ),
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),

                      // Separator dot
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.35,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      _LegalChip(
                        label: AppLocalizations.of(context)!.privacyPolicy,
                        onTap: () => OnboardingLegalModal.show(
                          context,
                          title: 'Privacy Policy',
                          content: kPrivacyPolicy,
                        ),
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ],
                  ),
                ],
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

class _LegalChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _LegalChip({
    required this.label,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
