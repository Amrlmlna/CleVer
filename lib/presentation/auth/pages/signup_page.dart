import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/custom_snackbar.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../providers/signup_controller.dart';
import '../widgets/signup_header.dart';
import '../widgets/signup_form.dart';
import '../widgets/social_login_section.dart';
import '../widgets/login_footer.dart';

import 'package:clever/l10n/generated/app_localizations.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});

  void _showLoadingOverlay(BuildContext context, String message) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            AppLoadingScreen(
              messages: [
                message,
                AppLocalizations.of(context)!.finalizing,
                AppLocalizations.of(context)!.ready,
              ],
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

    ref.listen<AsyncValue<void>>(signupControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }

          final errorMessage = error.toString();
          if (errorMessage.contains('google')) {
            CustomSnackBar.showError(
              context,
              l10n.googleSignInError(errorMessage),
            );
          } else {
            CustomSnackBar.showError(context, errorMessage);
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SignupHeader(),
              const SizedBox(height: 32),
              const SignupForm(),
              const SizedBox(height: 24),
              SocialLoginSection(
                onGoogleSignIn: () async {
                  _showLoadingOverlay(context, l10n.googleSignInSuccess);
                  final success = await ref
                      .read(signupControllerProvider.notifier)
                      .signUpWithGoogle();

                  if (context.mounted) {
                    if (success) {
                      Navigator.of(context).pop();
                      context.go('/');
                    }
                  }
                },
              ),
              const SizedBox(height: 24),
              const LoginFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
