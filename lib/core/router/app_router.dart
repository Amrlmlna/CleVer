import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/onboarding/pages/onboarding_welcome_page.dart';
import '../../presentation/onboarding/pages/onboarding_page.dart';
import '../../presentation/onboarding/providers/onboarding_provider.dart';
import '../../presentation/home/pages/home_page.dart';
import '../../presentation/dashboard/pages/main_wrapper_page.dart';
import '../../presentation/notifications/pages/notifications_page.dart';
import '../../presentation/drafts/pages/drafts_page.dart';
import '../../presentation/profile/pages/profile_page.dart';
import '../../presentation/cv/pages/job_input_page.dart';
import '../../presentation/cv/pages/user_data_form_page.dart';
import '../../presentation/stats/pages/stats_page.dart';
import '../../presentation/templates/pages/style_selection_page.dart';
import '../../presentation/support/pages/help_page.dart';
import '../../presentation/support/pages/feedback_page.dart';
import '../../presentation/legal/pages/legal_page.dart';
import '../../presentation/common/pages/error_page.dart';
import '../../presentation/auth/pages/login_page.dart';
import '../../presentation/auth/pages/signup_page.dart';
import '../../domain/entities/tailored_cv_result.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingCompleted = ref.watch(onboardingProvider);
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final isGoingToOnboarding = state.uri.toString().startsWith(AppRoutes.onboarding);
      
      if (!onboardingCompleted && !isGoingToOnboarding) {
        return AppRoutes.onboarding;
      }

      if (onboardingCompleted && isGoingToOnboarding) {
        return AppRoutes.home;
      }

      return null;
    },
    observers: [
      PosthogObserver(),
    ],
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),
      
      // System & Shared Routes
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: AppRoutes.error,
        builder: (context, state) {
          final args = state.extra as ErrorPageArgs?;
          return ErrorPage(
            args: args ?? ErrorPageArgs(
              title: AppLocalizations.of(context)!.unknownError,
              message: AppLocalizations.of(context)!.unknownErrorDesc,
            ),
          );
        },
      ),
      
      // Onboarding Flow
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingWelcomePage(),
        routes: [
          GoRoute(
            path: 'form', // Relative to /onboarding
            builder: (context, state) => const OnboardingPage(),
          ),
        ],
      ),
      
      // Main Application Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapperPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'preview',
                    parentNavigatorKey: _rootNavigatorKey,
                    redirect: (context, state) => AppRoutes.home,
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'help',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const HelpPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      
      // Standalone Content Routes
      GoRoute(
        path: AppRoutes.feedback,
        builder: (context, state) => const FeedbackPage(),
      ),
      GoRoute(
        path: AppRoutes.legal,
        builder: (context, state) => const LegalPage(),
      ),
      GoRoute(
        path: AppRoutes.drafts,
        builder: (context, state) => const DraftsPage(),
      ),
      GoRoute(
        path: AppRoutes.stats,
        builder: (context, state) => const StatsPage(),
      ),
      
      // CV Generation Flow
      GoRoute(
        path: AppRoutes.createJobInput,
        builder: (context, state) => const JobInputPage(),
      ),
      GoRoute(
        path: AppRoutes.createUserData,
        builder: (context, state) {
          final tailoredResult = state.extra as TailoredCVResult?;
          return UserDataFormPage(tailoredResult: tailoredResult);
        },
      ),
      GoRoute(
        path: AppRoutes.createStyleSelection,
        builder: (context, state) => const StyleSelectionPage(),
      ),
    ],
  );
});
