import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../profile/providers/profile_sync_provider.dart';

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
      leading: IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () => context.push('/notifications'),
      ),
      title: title != null ? Text(title!) : null,
      centerTitle: true,
      actions: [
        if (user != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'sync') {
                  ref.read(profileSyncProvider).initialCloudFetch(user.uid);
                } else if (value == 'logout') {
                  await ref.read(authRepositoryProvider).signOut();
                }
              },
              offset: const Offset(0, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'sync',
                  child: ListTile(
                    leading: Icon(Icons.sync, size: 20),
                    title: Text('Sync Data'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red, size: 20),
                    title: Text('Log Out', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
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
