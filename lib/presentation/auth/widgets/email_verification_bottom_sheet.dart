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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
               color: Theme.of(context).dividerTheme.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            widget.title ?? AppLocalizations.of(context)!.verifyYourEmail,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            widget.description ??
                AppLocalizations.of(context)!.verificationSentTo(email),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),

          if (widget.extensionContent != null) ...[
            const SizedBox(height: 24),
            widget.extensionContent!,
          ],

          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)),
            ),
            child: Text(
              AppLocalizations.of(context)!.checkSpamFolder,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isChecking ? null : _checkStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isChecking
                  ? SpinningTextLoader(
                      texts: [
                        AppLocalizations.of(context)!.checkingSystem,
                        AppLocalizations.of(context)!.validatingLink,
                        AppLocalizations.of(context)!.almostThere,
                      ],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.iHaveVerified,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          TextButton(
            onPressed: _isResending ? null : _resendLink,
            child: Text(
              _isResending
                  ? AppLocalizations.of(context)!.sending
                  : AppLocalizations.of(context)!.resendEmail,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
