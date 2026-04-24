import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../widgets/social_login_button.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback onGoogleSignIn;

  const SocialLoginSection({super.key, required this.onGoogleSignIn});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.or,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
          ],
        ),
        const SizedBox(height: 24),
        SocialLoginButton(
          onPressed: onGoogleSignIn,
          text: l10n.continueWithGoogle,
          icon: Image.asset('assets/images/google_logo.png', height: 24),
          isLoading: false,
        ),
      ],
    );
  }
}
