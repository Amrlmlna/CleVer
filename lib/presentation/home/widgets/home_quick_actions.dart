import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../../profile/providers/profile_provider.dart';
import '../../profile/utils/cv_import_handler.dart';
import '../../auth/utils/auth_guard.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class HomeQuickActions extends ConsumerWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickActionCircle(
          icon: Icons.document_scanner_outlined,
          label: AppLocalizations.of(context)!.importCV,
          onTap: () {
            CVImportHandler.showImportDialog(
              context: context,
              ref: ref,
              onImportSuccess: (UserProfile importedProfile) async {
                await ref
                    .read(masterProfileProvider.notifier)
                    .mergeProfile(importedProfile);

                if (context.mounted) {
                  context.go('/profile');
                }
              },
            );
          },
        ),
        _QuickActionCircle(
          icon: Icons.work_outline,
          label: AppLocalizations.of(context)!.jobs,
          onTap: () {
            context.push('/jobs');
          },
        ),
        _QuickActionCircle(
          icon: Icons.bar_chart_rounded,
          label: AppLocalizations.of(context)!.statistics,
          onTap: () {
            context.push('/stats');
          },
        ),
        _QuickActionCircle(
          icon: Icons.add_circle_outline,
          label: AppLocalizations.of(context)!.createCV,
          onTap: AuthGuard.protected(
            context,
            () {
              context.push('/create/job-input');
            },
            featureTitle: AppLocalizations.of(context)!.authWallCreateCV,
            featureDescription: AppLocalizations.of(
              context,
            )!.authWallCreateCVDesc,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCircle({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            child: Icon(icon, color: colorScheme.onSurface, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
