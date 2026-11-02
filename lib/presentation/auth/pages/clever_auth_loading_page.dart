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
import '../../profile/providers/profile_sync_provider.dart';
import '../../profile/providers/master_profile_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';

/// Post-auth loading screen ("SignInFormLoading"). Waits for the Firebase
/// auth state and routes onward: completed onboarding → home (legacy users
/// arriving through the auth wall), existing accounts with a cloud profile
/// → home directly (their data is already set), fresh accounts → the
/// welcome questionnaire.
class CleverAuthLoadingPage extends ConsumerStatefulWidget {
  const CleverAuthLoadingPage({super.key});

  @override
  ConsumerState<CleverAuthLoadingPage> createState() =>
      _CleverAuthLoadingPageState();
}

class _CleverAuthLoadingPageState extends ConsumerState<CleverAuthLoadingPage> {
  bool _navigated = false;

  Future<void> _navigateIfSignedIn(AppUser? user) async {
    if (user == null || _navigated || !mounted) return;
    _navigated = true;

    final onboarded = ref.read(onboardingProvider);
    var route = AppRoutes.onboardingSteps;

    if (onboarded) {
      route = AppRoutes.home;
    } else {
      // Auth-first: an existing account may already carry a complete
      // profile from another device or the legacy flow. Pull it and skip
      // the questionnaire when it has real data. If the fetch fails
      // (offline, Firebase hiccup), degrade to onboarding — the profile
      // heartbeat merges the cloud data in the background either way.
      try {
        await ref.read(profileSyncProvider).initialCloudFetch(user.uid);
      } catch (_) {}

      final profile = ref.read(masterProfileProvider);
      final hasCloudProfile =
          profile != null &&
          (profile.fullName.isNotEmpty ||
              profile.experience.isNotEmpty ||
              profile.education.isNotEmpty ||
              profile.certifications.isNotEmpty ||
              profile.skills.isNotEmpty);

      if (hasCloudProfile) {
        await ref.read(onboardingProvider.notifier).completeOnboarding();
        route = AppRoutes.home;
      }
    }

    if (!mounted) return;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // The auth state may already be resolved when this screen opens.
    final current = ref.watch(authStateProvider).value;
    if (current != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateIfSignedIn(current);
      });
    }
    ref.listen<AsyncValue<AppUser?>>(authStateProvider, (_, next) {
      _navigateIfSignedIn(next.value);
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
