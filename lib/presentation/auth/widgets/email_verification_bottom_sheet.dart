import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../common/widgets/spinning_text_loader.dart';
import '../../../core/utils/custom_snackbar.dart';
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
      backgroundColor: Colors.transparent,
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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.title ?? l10n.verifyYourEmail,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.description ?? l10n.verificationSentTo(email),
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (widget.extensionContent != null) ...[
            const SizedBox(height: 24),
            widget.extensionContent!,
          ],
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.checkSpamFolder,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isChecking ? null : _checkStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.onSurface,
                foregroundColor: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isChecking
                  ? SpinningTextLoader(
                      texts: [
                        l10n.checkingSystem,
                        l10n.validatingLink,
                        l10n.almostThere,
                      ],
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.surface,
                      ),
                    )
                  : Text(
                      l10n.iHaveVerified.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 1.0,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _isResending ? null : _resendLink,
            child: Text(
              (_isResending ? l10n.sending : l10n.resendEmail).toUpperCase(),
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
