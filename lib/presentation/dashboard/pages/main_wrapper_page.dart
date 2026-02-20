import 'dart:ui';
import '../../auth/utils/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/widgets/custom_app_bar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../profile/providers/profile_provider.dart';

import '../../auth/widgets/email_verification_dialog.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../../domain/entities/app_user.dart';
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
  bool _dialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVerification(ref.read(authStateProvider).value);
    });
  }

  void _checkVerification(AppUser? user) {
    if (user == null) return;
    
    // Social providers are usually pre-verified by Google/Apple
    final firebaseUser = fb.FirebaseAuth.instance.currentUser;
    final isPasswordProvider = firebaseUser?.providerData.any((p) => p.providerId == 'password') ?? false;
    
    if (isPasswordProvider && !firebaseUser!.emailVerified && !_dialogShowing) {
      _dialogShowing = true;
      EmailVerificationDialog.show(context).then((_) {
        _dialogShowing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth changes to trigger dialog
    ref.listen(authStateProvider, (previous, next) {
       _checkVerification(next.value);
    });

    return Scaffold(
      appBar: const CustomAppBar(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          widget.navigationShell,
        ],
      ),
      floatingActionButton: _buildCenterFAB(context),
      floatingActionButtonLocation: const _CenterDockedFabLocation(),
      bottomNavigationBar: _buildBottomNav(context, ref),
    );
  }

  Widget _buildCenterFAB(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFE0E0E0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1), 
            blurRadius: 6, 
            offset: const Offset(0, 2), 
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: AuthGuard.protected(context, () {
            context.push('/create/job-input');
          }),
          customBorder: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.transparent, 
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), 
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
          child: Container(
            color: (isDark ? const Color(0xFF1E1E1E) : Colors.black).withValues(alpha: 0.8), 
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context, ref, 0, Icons.home_rounded, 'Home'),
                
                const SizedBox(width: 60), 
                
                _buildNavItem(context, ref, 1, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, WidgetRef ref, int index, IconData icon, String label) {
    final isSelected = widget.navigationShell.currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = Colors.white;
    final inactiveColor = Colors.white.withValues(alpha: 0.5);

    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () async {
          if (index != widget.navigationShell.currentIndex) {
            if (widget.navigationShell.currentIndex == 1) {
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
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.2))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: isSelected ? activeColor : inactiveColor,
            size: 26, 
          ),
        ),
      ),
    );
  }
}

class _CenterDockedFabLocation extends StandardFabLocation
    with FabCenterOffsetX, FabDockedOffsetY {
  const _CenterDockedFabLocation();

  @override
  double getOffsetY(ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double safeAreaBottom = scaffoldGeometry.minInsets.bottom;
    
    double fabY = scaffoldGeometry.scaffoldSize.height - 120 - safeAreaBottom; 
    
    if (bottomSheetHeight > 0.0) {
      fabY = scaffoldGeometry.scaffoldSize.height - bottomSheetHeight - fabHeight - 16;
    }

    final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
    return fabY.clamp(0.0, maxFabY);
  }
}
