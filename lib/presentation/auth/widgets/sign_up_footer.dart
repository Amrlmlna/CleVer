import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.dontHaveAccount,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        TextButton(
          onPressed: () => context.push('/signup'),
          child: Text(
            l10n.signUp.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
