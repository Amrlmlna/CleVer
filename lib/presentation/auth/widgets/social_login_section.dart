import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../widgets/social_login_button.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback onGoogleSignIn;

  const SocialLoginSection({super.key, required this.onGoogleSignIn});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.grey200)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.or.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.grey400,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.grey200)),
          ],
        ),
        const SizedBox(height: 24),
        SocialLoginButton(
          onPressed: onGoogleSignIn,
          text: l10n.continueWithGoogle.toUpperCase(),
          icon: Image.asset('assets/images/google_logo.png', height: 20),
          isLoading: false,
        ),
      ],
    );
  }
}
