import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/custom_snackbar.dart';
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
          icon: Icons.upload_file,
          label: AppLocalizations.of(context)!.importCV,
          onTap: () {
            CVImportHandler.showImportDialog(
              context: context,
              ref: ref,
              onImportSuccess: (UserProfile importedProfile) async {
                final hasChanges = await ref
                    .read(masterProfileProvider.notifier)
                    .mergeProfile(importedProfile);

                if (context.mounted) {
                  if (hasChanges) {
                    CustomSnackBar.showSuccess(
                      context,
                      AppLocalizations.of(context)!.cvImportedSuccess,
                    );
                  } else {
                    CustomSnackBar.showInfo(
                      context,
                      AppLocalizations.of(context)!.cvDataExists,
                    );
                  }
                  context.go('/profile');
                }
              },
            );
          },
        ),
        _QuickActionCircle(
          icon: Icons.work_outline,
          label: 'Jobs',
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade300,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
