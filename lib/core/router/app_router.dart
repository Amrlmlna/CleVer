import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/main_wrapper_page.dart';
import '../../presentation/pages/drafts_page.dart';
import '../../presentation/pages/ai_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../presentation/pages/job_input_page.dart';
import '../../presentation/pages/user_data_form_page.dart';
import '../../presentation/pages/style_selection_page.dart';
import '../../presentation/pages/cv_preview_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKey = GlobalKey<NavigatorState>(); // Unused

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
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
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/drafts',
                builder: (context, state) => const DraftsPage(),
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
        path: '/preview',
        builder: (context, state) => const CVPreviewPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
});
