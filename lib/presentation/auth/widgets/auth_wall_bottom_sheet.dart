import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../../core/router/app_routes.dart';
import '../../profile/providers/profile_sync_provider.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/social_login_button.dart';
import '../../home/widgets/mascot_header.dart';
import '../../home/models/mascot_state.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class AuthWallBottomSheet extends ConsumerStatefulWidget {
  final String? featureTitle;
  final String? featureDescription;
  final VoidCallback? onAuthenticated;
  final VoidCallback? onDismiss;

  const AuthWallBottomSheet({
    super.key,
    this.featureTitle,
    this.featureDescription,
    this.onAuthenticated,
    this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    String? featureTitle,
    String? featureDescription,
    VoidCallback? onAuthenticated,
    VoidCallback? onDismiss,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => AuthWallBottomSheet(
        featureTitle: featureTitle,
        featureDescription: featureDescription,
        onAuthenticated: onAuthenticated,
        onDismiss: onDismiss,
      ),
    );

    if (result == null) {
      onDismiss?.call();
    }
  }

  @override
  ConsumerState<AuthWallBottomSheet> createState() =>
      _AuthWallBottomSheetState();
}

class _AuthWallBottomSheetState extends ConsumerState<AuthWallBottomSheet> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.signInWithGoogle();

      if (user != null && mounted) {
        try {
          await ref.read(profileSyncProvider).initialCloudFetch(user.uid);
        } catch (e) {
          debugPrint("Sync failed after google signin: $e");
        }

        if (mounted) {
          Navigator.of(context).pop(true);
          widget.onAuthenticated?.call();
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Theme(
      data: AppTheme.sheetTheme,
      child: Builder(
        builder: (context) {
          final sheetTheme = Theme.of(context);
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.only(bottom: 32),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -40,
                  top: 60,
                  child: Icon(
                    Icons.lock_person_outlined,
                    size: 240,
                    color: Colors.black.withValues(alpha: 0.04),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 40),
                      child: const MascotHeader(
                        expression: MascotExpression.exciting,
                        mascotColor: AppColors.vibrantPurple,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Text(
                            (widget.featureTitle ?? l10n.loginToSave)
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                              letterSpacing: -1.0,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.featureDescription ?? l10n.syncAnywhere,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.grey600,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          SocialLoginButton(
                            onPressed: _isLoading ? null : _signInWithGoogle,
                            text: l10n.continueWithGoogle.toUpperCase(),
                            icon: Image.asset(
                              'assets/images/google_logo.png',
                              height: 20,
                            ),
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      Navigator.of(context).pop(false);
                                      context.push(AppRoutes.login);
                                    },
                              icon: const Icon(Icons.email_outlined, size: 20),
                              label: Text(l10n.login.toUpperCase()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.black,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.dontHaveAccount,
                          style: TextStyle(
                            color: AppColors.grey500,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                            context.push(AppRoutes.signup);
                          },
                          child: Text(
                            l10n.signUp.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.vibrantPurple,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
