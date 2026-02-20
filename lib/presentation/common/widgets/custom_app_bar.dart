import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../profile/providers/profile_sync_provider.dart';
import '../../common/widgets/language_selector.dart';

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
      leading: const BackButton(),
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
                      const Icon(Icons.logout, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.logOut),
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
