import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_dimensions.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../common/widgets/clever/clever_button.dart';
import '../../common/widgets/spinning_text_loader.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class EmailVerificationBottomSheet extends ConsumerStatefulWidget {
  final String? title;
  final String? description;
  final IconData? icon;
  final Widget? extensionContent;
  final VoidCallback? onVerified;

  const EmailVerificationBottomSheet({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.extensionContent,
    this.onVerified,
  });

  static Future<void> show(
    BuildContext context, {
    String? title,
    String? description,
    IconData? icon,
    Widget? extensionContent,
    VoidCallback? onVerified,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: CleverColors.bgCanvas,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      builder: (context) => EmailVerificationBottomSheet(
        title: title,
        description: description,
        icon: icon,
        extensionContent: extensionContent,
        onVerified: onVerified,
      ),
    );
  }

  @override
  ConsumerState<EmailVerificationBottomSheet> createState() =>
      _EmailVerificationBottomSheetState();
}

class _EmailVerificationBottomSheetState
    extends ConsumerState<EmailVerificationBottomSheet> {
  bool _isChecking = false;
  bool _isResending = false;

  Future<void> _checkStatus() async {
    setState(() => _isChecking = true);

    try {
      await ref.read(authRepositoryProvider).reloadUser();
      final user = fb.FirebaseAuth.instance.currentUser;

      if (user?.emailVerified ?? false) {
        // Force-refresh the Firebase ID token so its email_verified claim
        // matches the updated FirebaseAuth state. The backend checks this
        // claim on every request — without a refresh the old token (stale
        // for ~1h) would keep returning 403 EMAIL_NOT_VERIFIED.
        await user!.getIdToken(true);

        if (mounted) {
          Navigator.pop(context);
          widget.onVerified?.call();
          CustomSnackBar.showSuccess(
            context,
            AppLocalizations.of(context)!.emailVerifiedSuccess,
          );
        }
      } else {
        if (mounted) {
          CustomSnackBar.showWarning(
            context,
            AppLocalizations.of(context)!.emailNotVerifiedYet,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  Future<void> _resendLink() async {
    setState(() => _isResending = true);
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
      if (mounted) {
        CustomSnackBar.showSuccess(
          context,
          AppLocalizations.of(context)!.verificationEmailSent,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = fb.FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: CleverColors.bgCanvas,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        31,
        16,
        33,
        MediaQuery.of(context).padding.bottom + 24,
      ),
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
            widget.title ?? l10n.verifyYourEmail,
            textAlign: TextAlign.center,
            style: CleverTypography.h1.copyWith(
              color: CleverColors.textPrimary,
            ),
          ),
          const SizedBox(height: CleverSpacing.space12),
          Text(
            widget.description ?? l10n.verificationSentTo(email),
            textAlign: TextAlign.center,
            style: CleverTypography.body.copyWith(
              color: CleverColors.textSecondary,
            ),
          ),
          if (widget.extensionContent != null) ...[
            const SizedBox(height: CleverSpacing.space24),
            widget.extensionContent!,
          ],
          const SizedBox(height: CleverSpacing.space24),
          Container(
            padding: const EdgeInsets.all(CleverSpacing.space16),
            decoration: BoxDecoration(
              color: CleverColors.surfaceSelected,
              borderRadius: BorderRadius.circular(CleverRadius.card),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: CleverColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: CleverSpacing.space16),
                Expanded(
                  child: Text(
                    l10n.checkSpamFolder,
                    style: CleverTypography.bodySm.copyWith(
                      color: CleverColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: CleverSpacing.space24),
          CleverButton(
            label: _isChecking ? '' : l10n.iHaveVerified,
            onTap: _isChecking ? null : _checkStatus,
          ),
          const SizedBox(height: CleverSpacing.space16),
          if (_isChecking)
            SizedBox(
              height: 20,
              child: SpinningTextLoader(
                texts: [
                  l10n.checkingSystem,
                  l10n.validatingLink,
                  l10n.almostThere,
                ],
                style: CleverTypography.bodyStrong.copyWith(
                  color: CleverColors.textSecondary,
                ),
                interval: const Duration(milliseconds: 800),
              ),
            )
          else
            TextButton(
              onPressed: _isResending ? null : _resendLink,
              child: Text(
                _isResending ? l10n.sending : l10n.resendEmail,
                style: CleverTypography.bodyStrong.copyWith(
                  color: CleverColors.textLink,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
