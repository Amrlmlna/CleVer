import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
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
                  const LoginHeader(),
                  const SizedBox(height: 48),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: LoginForm(),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SocialLoginSection(
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
                  ),
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: SignUpFooter(),
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
