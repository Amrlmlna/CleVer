import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/providers/profile_provider.dart';
import '../../auth/providers/auth_state_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class WelcomeHeader extends ConsumerWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final profile = ref.watch(masterProfileProvider);
    final displayName = ref.watch(userDisplayNameProvider);

    final name =
        profile?.fullName.split(' ').first ??
        displayName?.split(' ').first ??
        'there';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.helloName(name),
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context)!.readyToAchieve,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
