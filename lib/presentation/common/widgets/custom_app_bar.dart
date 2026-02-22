import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../profile/providers/profile_sync_provider.dart';
import '../../common/widgets/language_selector.dart';
import '../../profile/providers/profile_provider.dart';
import '../../profile/widgets/delete_account_dialog.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/router/app_routes.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  
  const CustomAppBar({super.key, this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoUrl = ref.watch(userPhotoUrlProvider);
    final user = ref.watch(authStateProvider).value;

    return AppBar(
      backgroundColor: Colors.transparent,
      forceMaterialTransparency: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (Navigator.of(context).canPop())
              const BackButton()
            else
              Consumer(
                builder: (context, ref, child) {
                  final unreadCount = ref.watch(unreadNotificationCountProvider);
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                        onPressed: () => context.push(AppRoutes.notifications),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              unreadCount > 9 ? '9+' : '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
      leadingWidth: 100,
      title: title != null ? Text(title!) : null,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const LanguageSelector(),
        ),
        const SizedBox(width: 8),
        if (user != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'sync') {
                  ref.read(profileSyncProvider).initialCloudFetch(user.uid);
                } else if (value == 'logout') {
                  await ref.read(authRepositoryProvider).signOut();
                } else if (value == 'delete') {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => const DeleteAccountDialog(),
                  );
                  if (confirmed == true) {
                    try {
                      await ref.read(profileControllerProvider.notifier).deleteAccount();
                      if (context.mounted) {
                        CustomSnackBar.showSuccess(context, 'Account successfully deleted. Goodbye!');
                        context.go('/');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        CustomSnackBar.showError(context, 'Failed to delete account: $e');
                      }
                    }
                  }
                }
              },
              offset: const Offset(0, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'sync',
                  child: Row(
                    children: [
                      const Icon(Icons.sync, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.syncData),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      const Icon(Icons.logout, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.logOut),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_forever_rounded, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text('Delete Account', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null 
                      ? const Icon(Icons.person, size: 20, color: Colors.white) 
                      : null,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
