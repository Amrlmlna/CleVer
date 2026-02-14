import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/custom_snackbar.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickActionCircle(
          icon: Icons.upload_file,
          label: 'Import CV',
          onTap: () {
            // Navigate to profile which has import button
            context.push('/profile');
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
          icon: Icons.more_horiz,
          label: 'Lainnya',
          onTap: () {
            // TODO: Show more options menu
            _showMoreMenu(context);
          },
        ),
      ],
    );
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.white),
              title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                context.push('/profile/help');
              },
            ),
          ],
        ),
      ),
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
