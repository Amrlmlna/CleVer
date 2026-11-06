import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../core/services/analytics_service.dart';
import '../../common/widgets/clever/clever_button.dart';
import '../../common/widgets/clever/clever_divider.dart';
import '../../common/widgets/clever/clever_google_button.dart';
import '../../profile/providers/profile_sync_provider.dart';
import '../providers/auth_state_provider.dart';
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
      backgroundColor: CleverColors.bgCanvas,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      builder: (context) => AuthWallBottomSheet(
        featureTitle: featureTitle,
        featureDescription: featureDescription,
        onAuthenticated: onAuthenticated,
        onDismiss: onDismiss,
      ),
    );

    if (result == null || result == false) {
      AnalyticsService().trackAuthGuardInteraction(
        'dismissed',
        feature: featureTitle,
      );
      onDismiss?.call();
    }
  }

  @override
  ConsumerState<AuthWallBottomSheet> createState() =>
      _AuthWallBottomSheetState();
}

class _AuthWallBottomSheetState extends ConsumerState<AuthWallBottomSheet> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().trackAuthGuardViewed(feature: widget.featureTitle);
  }

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
          AnalyticsService().trackAuthGuardInteraction(
            'success',
            feature: widget.featureTitle,
            method: 'google',
          );
          Navigator.of(context).pop(true);
          widget.onAuthenticated?.call();
        }
      }
    } catch (e) {
      if (mounted) {
        final errorStr = e.toString().toLowerCase();
        if (!errorStr.contains('canceled')) {
          CustomSnackBar.showError(context, e.toString());
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goLogin() {
    AnalyticsService().trackAuthGuardInteraction(
      'login_redirect',
      feature: widget.featureTitle,
    );
    Navigator.of(context).pop(false);
    context.push(AppRoutes.login);
  }

  void _goSignup() {
    AnalyticsService().trackAuthGuardInteraction(
      'signup_redirect',
      feature: widget.featureTitle,
    );
    Navigator.of(context).pop(false);
    context.push(AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: CleverColors.bgCanvas,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(31, 16, 33, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 47,
              height: 4,
              decoration: BoxDecoration(
                color: CleverColors.surfaceInverse.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: CleverSpacing.space24),
          Text(
            widget.featureTitle ?? l10n.loginToSave,
            textAlign: TextAlign.center,
            style: CleverTypography.h1.copyWith(
              color: CleverColors.textPrimary,
            ),
          ),
          const SizedBox(height: CleverSpacing.space12),
          Text(
            widget.featureDescription ?? l10n.syncAnywhere,
            textAlign: TextAlign.center,
            style: CleverTypography.body.copyWith(
              color: CleverColors.textSecondary,
            ),
          ),
          const SizedBox(height: CleverSpacing.space24),
          CleverGoogleButton(
            label: l10n.continueWithGoogle,
            onTap: _isLoading ? null : _signInWithGoogle,
          ),
          const SizedBox(height: CleverSpacing.space16),
          CleverDivider(label: l10n.or),
          const SizedBox(height: CleverSpacing.space16),
          CleverButton(label: l10n.login, onTap: _isLoading ? null : _goLogin),
          const SizedBox(height: CleverSpacing.space16),
          TextButton(
            onPressed: _isLoading ? null : _goSignup,
            child: Text.rich(
              TextSpan(
                text: '${l10n.dontHaveAccount} ',
                children: [
                  TextSpan(
                    text: l10n.signUp,
                    style: CleverTypography.h4Weight(
                      FontWeight.w600,
                    ).copyWith(color: CleverColors.textPrimary),
                  ),
                ],
                style: CleverTypography.h4Weight(
                  FontWeight.w400,
                ).copyWith(color: CleverColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
