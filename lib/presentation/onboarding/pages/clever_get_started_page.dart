import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/clever/clever_button.dart';
import '../../common/widgets/clever/clever_mascot.dart';

class CleverGetStartedPage extends StatelessWidget {
  const CleverGetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: CleverColors.bgCanvas,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned(
            left: -116,
            bottom: 0,
            child: CleverMascot(variant: CleverMascotVariant.getStarted),
          ),
          Positioned(
            left: 36,
            top: 68,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.cleverGetStartedTitle,
                  style: CleverTypography.h1.copyWith(
                    color: CleverColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.cleverGetStartedSubtitle1,
                  style: CleverTypography.bodyStrong.copyWith(
                    color: CleverColors.textPrimary,
                  ),
                ),
                Text(
                  l10n.cleverGetStartedSubtitle2,
                  style: CleverTypography.bodyStrong.copyWith(
                    color: CleverColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 18,
            right: 16,
            bottom: 42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CleverButton(
                  label: l10n.signUp,
                  style: CleverButtonStyle.canvas,
                  height: 52,
                  labelStyle: CleverTypography.h3.copyWith(
                    color: CleverColors.textPrimary,
                  ),
                  onTap: () => context.push(AppRoutes.signup),
                ),
                const SizedBox(height: 29),
                _LoginPrompt(l10n: l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.push(AppRoutes.login),
      style: TextButton.styleFrom(
        foregroundColor: CleverColors.textOnDark,
        padding: EdgeInsets.zero,
      ),
      child: Text.rich(
        TextSpan(
          text: '${l10n.alreadyHaveAccount} ',
          children: [
            TextSpan(
              text: l10n.logIn,
              style: CleverTypography.h4.copyWith(
                color: CleverColors.textOnDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          style: CleverTypography.h4.copyWith(
            color: CleverColors.textOnDark,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
