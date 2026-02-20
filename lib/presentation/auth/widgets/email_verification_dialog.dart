import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/widgets/spinning_text_loader.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../common/widgets/app_loading_screen.dart';

class EmailVerificationDialog extends ConsumerStatefulWidget {
  const EmailVerificationDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const EmailVerificationDialog(),
    );
  }

  @override
  ConsumerState<EmailVerificationDialog> createState() => _EmailVerificationDialogState();
}

class _EmailVerificationDialogState extends ConsumerState<EmailVerificationDialog> {
  bool _isResending = false;
  bool _isChecking = false;

  Future<void> _resendVerification() async {
    setState(() => _isResending = true);
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
      if (mounted) {
        CustomSnackBar.showSuccess(context, AppLocalizations.of(context)!.verificationEmailSent);
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

  Future<void> _checkVerificationStatus() async {
    if (_isChecking) return;
    
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) => AppLoadingScreen(
          messages: [
            AppLocalizations.of(context)!.validatingData,
            AppLocalizations.of(context)!.finalizing,
          ],
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    setState(() => _isChecking = true);
    
    try {
      await ref.read(authRepositoryProvider).reloadUser();
      final user = fb.FirebaseAuth.instance.currentUser;
      
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss loading screen
      }

      if (user?.emailVerified ?? false) {
        if (mounted) {
          Navigator.of(context).pop(); // Dismiss dialog
        }
      } else {
        if (mounted) {
          CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.emailNotVerifiedYet);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss loading screen if error
        CustomSnackBar.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = fb.FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mark_email_read_outlined,
                size: 48,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.verifyYourEmail,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.verificationSentTo(email),
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _checkVerificationStatus,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                      AppLocalizations.of(context)!.iHaveVerified,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _isResending ? null : _resendVerification,
              child: Text(
                _isResending 
                    ? AppLocalizations.of(context)!.sending 
                    : AppLocalizations.of(context)!.resendEmail,
                style: GoogleFonts.outfit(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 48),
            TextButton.icon(
              onPressed: () {
                ref.read(authRepositoryProvider).signOut();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.logout, size: 18),
              label: Text(
                AppLocalizations.of(context)!.backToLogin,
                style: GoogleFonts.outfit(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
