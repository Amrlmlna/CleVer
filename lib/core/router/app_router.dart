import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/home/pages/home_page.dart';
import '../../presentation/dashboard/pages/main_wrapper_page.dart';
import '../../presentation/drafts/pages/drafts_page.dart';

import '../../presentation/profile/pages/profile_page.dart';
import '../../presentation/cv/pages/job_input_page.dart';
import '../../presentation/cv/pages/user_data_form_page.dart';
import '../../presentation/cv/pages/cv_preview_page.dart';
import '../../presentation/templates/pages/style_selection_page.dart';
import '../../presentation/templates/pages/template_gallery_page.dart';
import '../../presentation/onboarding/pages/onboarding_page.dart';
import '../../presentation/onboarding/providers/onboarding_provider.dart';
import '../../domain/entities/user_profile.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();


final routerProvider = Provider<GoRouter>((ref) {
  final onboardingCompleted = ref.watch(onboardingProvider);
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      // If onboarding is NOT completed, redirect to /onboarding
      // Prevent infinite loop if already on /onboarding
      final isGoingToOnboarding = state.uri.toString() == '/onboarding';
      
      // 1. Not completed -> Force Onboarding
      if (!onboardingCompleted && !isGoingToOnboarding) {
        return '/onboarding';
      }

      // 2. Completed -> Prevent Onboarding
      if (onboardingCompleted && isGoingToOnboarding) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapperPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'preview',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CVPreviewPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/drafts',
                builder: (context, state) => const DraftsPage(),
                routes: [
                  GoRoute(
                    path: 'preview',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CVPreviewPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/create/job-input',
        builder: (context, state) => const JobInputPage(),
      ),
      GoRoute(
        path: '/create/user-data',
        builder: (context, state) {
          final tailoredProfile = state.extra as UserProfile?;
          return UserDataFormPage(tailoredProfile: tailoredProfile);
        },
      ),
      GoRoute(
        path: '/create/style-selection',
        builder: (context, state) => const StyleSelectionPage(),
      ),
      GoRoute(
        path: '/create/preview',
        builder: (context, state) => const CVPreviewPage(),
      ),

      GoRoute(
        path: '/templates',
        builder: (context, state) => const TemplateGalleryPage(),
      ),
    ],
  );
});
