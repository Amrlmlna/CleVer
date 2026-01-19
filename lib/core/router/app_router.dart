import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/home/pages/home_page.dart';
import '../../presentation/dashboard/pages/main_wrapper_page.dart';
import '../../presentation/drafts/pages/drafts_page.dart';
import '../../presentation/ai/pages/ai_page.dart';
import '../../presentation/profile/pages/profile_page.dart';
import '../../presentation/cv/pages/job_input_page.dart';
import '../../presentation/cv/pages/user_data_form_page.dart';
import '../../presentation/cv/pages/cv_preview_page.dart';
import '../../presentation/templates/pages/style_selection_page.dart';
import '../../presentation/templates/pages/template_gallery_page.dart';
import '../../presentation/onboarding/pages/onboarding_page.dart';
import '../../presentation/onboarding/providers/onboarding_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKey = GlobalKey<NavigatorState>(); // Unused

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingCompleted = ref.watch(onboardingProvider);
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      // If onboarding is NOT completed, redirect to /onboarding
      // Prevent infinite loop if already on /onboarding
      if (!onboardingCompleted) {
        if (state.uri.toString() != '/onboarding') {
          return '/onboarding';
        }
      } else {
        // If onboarding IS completed, but user tries to go to /onboarding, send them home
        if (state.uri.toString() == '/onboarding') {
          return '/';
        }
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
                path: '/ai-tools',
                builder: (context, state) => const AIPage(),
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
        builder: (context, state) => const UserDataFormPage(), 
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
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/templates',
        builder: (context, state) => const TemplateGalleryPage(),
      ),
    ],
  );
});
