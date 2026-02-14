import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../domain/entities/user_profile.dart';
import '../../profile/providers/profile_provider.dart';
import '../../profile/utils/cv_import_handler.dart';

class HomeQuickActions extends ConsumerWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickActionCircle(
          icon: Icons.upload_file,
          label: 'Import CV',
          onTap: () {
            CVImportHandler.showImportDialog(
              context: context,
              ref: ref,
              onImportSuccess: (UserProfile importedProfile) async {
                // Merge imported data with master profile
                final hasChanges = await ref
                    .read(masterProfileProvider.notifier)
                    .mergeProfile(importedProfile);
                
                if (context.mounted) {
                  if (hasChanges) {
                    CustomSnackBar.showSuccess(
                      context,
                      'CV berhasil diimport! Mari lengkapi profilmu.',
                    );
                  } else {
                    CustomSnackBar.showInfo(
                      context,
                      'Data CV sudah ada di profilmu.',
                    );
                  }
                  // Navigate to profile for review
                  context.push('/profile');
                }
              },
            );
          },
        ),
        _QuickActionCircle(
          icon: Icons.folder_open_rounded,
          label: 'Lihat Draft',
          onTap: () {
            // TODO: Navigate to drafts page or show bottom sheet
            context.push('/drafts');
          },
        ),
        _QuickActionCircle(
          icon: Icons.bar_chart_rounded,
          label: 'Statistik',
          onTap: () {
            // TODO: Show stats modal or page
            CustomSnackBar.showInfo(context, 'Statistik - Coming soon!');
          },
        ),
        _QuickActionCircle(
          icon: Icons.add_circle_outline,
          label: 'Buat CV',
          onTap: () {
            context.push('/create/job-input');
          },
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
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
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
