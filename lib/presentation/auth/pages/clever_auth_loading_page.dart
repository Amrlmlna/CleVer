import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../domain/entities/app_user.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/clever/clever_mascot.dart';
import '../providers/auth_state_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';

/// Post-auth loading screen ("SignInFormLoading"). Waits for the Firebase
/// auth state and routes onward: completed onboarding → home (legacy users
/// arriving through the auth wall), otherwise the welcome questionnaire.
class CleverAuthLoadingPage extends ConsumerWidget {
  const CleverAuthLoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    void navigateIfSignedIn(AppUser? user) {
      if (user == null) return;
      final onboarded = ref.read(onboardingProvider);
      context.go(onboarded ? AppRoutes.home : AppRoutes.onboardingSteps);
    }

    // The auth state may already be resolved when this screen opens.
    final current = ref.watch(authStateProvider).value;
    if (current != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) navigateIfSignedIn(current);
      });
    }
    ref.listen<AsyncValue<AppUser?>>(authStateProvider, (_, next) {
      navigateIfSignedIn(next.value);
    });

    return Scaffold(
      backgroundColor: CleverColors.bgCanvas,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned(
            left: -56,
            top: 107,
            child: CleverMascot(variant: CleverMascotVariant.authLoading),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 67,
            child: Text(
              l10n.login,
              textAlign: TextAlign.center,
              style: CleverTypography.h1.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 137,
            child: Center(
              child: SizedBox(
                width: 50,
                height: 47,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: CleverColors.surfaceInverse,
                ),
              ),
            ),
          ),
          Positioned(
            left: 52,
            bottom: 60,
            child: TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              style: TextButton.styleFrom(
                foregroundColor: CleverColors.textOnDark,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                l10n.cancel,
                style: CleverTypography.bodyStrong.copyWith(
                  color: CleverColors.textOnDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
