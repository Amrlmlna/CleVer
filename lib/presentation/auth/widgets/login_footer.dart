import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount,
          style: const TextStyle(color: AppColors.grey500),
        ),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text(
            l10n.logIn.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.vibrantPurple,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
