import '../../auth/utils/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/widgets/custom_app_bar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../profile/providers/profile_provider.dart';

import '../../auth/widgets/email_verification_bottom_sheet.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../../domain/entities/app_user.dart';
import '../../../core/services/notification_controller.dart';
import '../../common/widgets/in_app_notification.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class MainWrapperPage extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapperPage({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<MainWrapperPage> createState() => _MainWrapperPageState();
}

class _MainWrapperPageState extends ConsumerState<MainWrapperPage> {
  bool _sheetShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVerification(ref.read(authStateProvider).value);
    });

    NotificationController.displayStreamController.stream.listen((notification) {
      if (mounted) {
        InAppNotificationOverlay.show(
          context,
          title: (notification.title == null || notification.title!.isEmpty)
              ? AppLocalizations.of(context)!.notificationNew
              : notification.title!,
          body: notification.body ?? '',
        );
      }
    });
  }

  void _checkVerification(AppUser? user) {
    if (user == null) return;
    
    final firebaseUser = fb.FirebaseAuth.instance.currentUser;
    final isPasswordProvider = firebaseUser?.providerData.any((p) => p.providerId == 'password') ?? false;
    
    if (isPasswordProvider && !firebaseUser!.emailVerified && !_sheetShowing) {
      _sheetShowing = true;
      EmailVerificationBottomSheet.show(context).then((_) {
        _sheetShowing = false;
      });
    }
  }

  Future<void> _onTabTap(int index) async {
    if (index != widget.navigationShell.currentIndex) {
      if (widget.navigationShell.currentIndex == 3) {
        final hasUnsavedChanges = ref.read(profileControllerProvider).hasChanges;
        
        if (hasUnsavedChanges) {
          final shouldLeave = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.saveChangesTitle),
              content: Text(AppLocalizations.of(context)!.saveChangesMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), 
                  child: Text(AppLocalizations.of(context)!.stayHere),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(profileControllerProvider.notifier).discardChanges();
                    Navigator.pop(context, true); 
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(AppLocalizations.of(context)!.exitWithoutSaving),
                ),
              ],
            ),
          );

          if (shouldLeave != true) return; 
        }
      }
    }
    
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (previous, next) {
       _checkVerification(next.value);
    });

    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      appBar: const CustomAppBar(),
      extendBodyBehindAppBar: true,
      body: widget.navigationShell,
      floatingActionButton: _buildCenterFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E1E1E),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        height: 64,
        child: Row(
          children: [
            _buildNavItem(context, 0, Icons.home_outlined, Icons.home_rounded, AppLocalizations.of(context)!.home, currentIndex),
            _buildNavItem(context, 1, Icons.description_outlined, Icons.description_rounded, AppLocalizations.of(context)!.myDrafts, currentIndex),
            const SizedBox(width: 64),
            _buildNavItem(context, 2, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet_rounded, AppLocalizations.of(context)!.wallet, currentIndex),
            _buildNavItem(context, 3, Icons.person_outline, Icons.person_rounded, AppLocalizations.of(context)!.profile, currentIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterFAB(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: FloatingActionButton(
        onPressed: AuthGuard.protected(context, () {
          context.push('/create/job-input');
        }),
        backgroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, IconData activeIcon, String label, int currentIndex) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? Colors.white : Colors.white38,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : Colors.white38,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
