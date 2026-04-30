import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/utils/auth_guard.dart';
import '../../profile/utils/cv_import_handler.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../domain/entities/user_profile.dart';

class BentoQuickActions extends ConsumerWidget {
  const BentoQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _BentoTile(
              title: l10n.createCV,
              icon: Icons.add_circle_outline,
              color: colorScheme.surface,
              textColor: colorScheme.onSurface,
              onTap: AuthGuard.protected(
                context,
                () => context.push('/create/job-input'),
                featureTitle: l10n.authWallCreateCV,
                featureDescription: l10n.authWallCreateCVDesc,
              ),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: _BentoTile(
              title: l10n.jobs,
              icon: Icons.work_outline,
              color: AppColors.vibrantBlue,
              textColor: AppColors.white,
              onTap: () => context.push('/jobs'),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _BentoTile(
              title: l10n.importCV,
              icon: Icons.document_scanner_outlined,
              color: AppColors.vibrantBlack,
              textColor: AppColors.white,
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
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: _BentoTile(
              title: l10n.wallet,
              icon: Icons.account_balance_wallet_outlined,
              color: AppColors.vibrantYellow,
              textColor: AppColors.black,
              onTap: () => context.push('/wallet'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _BentoTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: textColor, size: 24),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
