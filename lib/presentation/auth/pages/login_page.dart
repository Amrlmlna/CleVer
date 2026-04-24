import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/custom_snackbar.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../providers/login_controller.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';
import '../widgets/social_login_section.dart';
import '../widgets/sign_up_footer.dart';

import 'package:clever/l10n/generated/app_localizations.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void _showLoadingOverlay(BuildContext context, String message) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            AppLoadingScreen(
              messages: [message, AppLocalizations.of(context)!.finalizing],
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          CustomSnackBar.showError(context, error.toString());
        },
      );
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginHeader(),
                const SizedBox(height: 48),
                const LoginForm(),
                const SizedBox(height: 24),
                SocialLoginSection(
                  onGoogleSignIn: () async {
                    _showLoadingOverlay(context, l10n.googleSignInSuccess);
                    final success = await ref
                        .read(loginControllerProvider.notifier)
                        .signInWithGoogle();

                    if (context.mounted) {
                      if (success) {
                        Navigator.of(context).pop();
                        CustomSnackBar.showSuccess(
                          context,
                          l10n.welcomeBackSuccess,
                        );
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 24),
                const SignUpFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
