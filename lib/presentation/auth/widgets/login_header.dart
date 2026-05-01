import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/widgets/mascot_header.dart';
import '../../home/models/mascot_state.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.only(top: 60),
          child: const MascotHeader(
            expression: MascotExpression.exciting,
            mascotColor: AppColors.vibrantPurple,
          ),
        ),

        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.welcomeBack.toUpperCase(),
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                  fontSize: 42,
                  letterSpacing: -2.0,
                  height: 0.9,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.vibrantPurple,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.signInSubtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
