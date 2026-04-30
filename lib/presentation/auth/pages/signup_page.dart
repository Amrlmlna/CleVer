import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
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
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned(
            right: -60,
            top: 100,
            child: Icon(
              Icons.lock_person_outlined,
              size: 320,
              color: Colors.black.withValues(alpha: 0.03),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SignupHeader(),
                  const SizedBox(height: 48),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: SignupForm(),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SocialLoginSection(
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
                  ),
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: LoginFooter(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.grey100,
                  foregroundColor: AppColors.black,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
