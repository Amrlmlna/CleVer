import 'package:clever/core/router/app_router.dart';
import 'package:clever/core/router/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('redirect guard matrix', () {
    test('unauthenticated new user: auth routes stay reachable', () {
      expect(
        resolveRedirect(
          location: AppRoutes.signup,
          onboardingCompleted: false,
          isAuthenticated: false,
        ),
        isNull,
      );
      expect(
        resolveRedirect(
          location: AppRoutes.login,
          onboardingCompleted: false,
          isAuthenticated: false,
        ),
        isNull,
      );
    });

    test('unauthenticated new user: everything else funnels to onboarding', () {
      expect(
        resolveRedirect(
          location: AppRoutes.home,
          onboardingCompleted: false,
          isAuthenticated: false,
        ),
        AppRoutes.onboarding,
      );
    });

    test('unauthenticated user cannot reach questionnaire or loading', () {
      expect(
        resolveRedirect(
          location: AppRoutes.onboardingSteps,
          onboardingCompleted: false,
          isAuthenticated: false,
        ),
        AppRoutes.onboarding,
      );
      expect(
        resolveRedirect(
          location: AppRoutes.onboardingLoading,
          onboardingCompleted: false,
          isAuthenticated: false,
        ),
        AppRoutes.onboarding,
      );
    });

    test('authenticated new user: auth routes never shown again', () {
      expect(
        resolveRedirect(
          location: AppRoutes.signup,
          onboardingCompleted: false,
          isAuthenticated: true,
        ),
        AppRoutes.onboardingSteps,
      );
      expect(
        resolveRedirect(
          location: AppRoutes.login,
          onboardingCompleted: false,
          isAuthenticated: true,
        ),
        AppRoutes.onboardingSteps,
      );
    });

    test('authenticated returning user skips GetStarted, resumes steps', () {
      expect(
        resolveRedirect(
          location: AppRoutes.onboarding,
          onboardingCompleted: false,
          isAuthenticated: true,
        ),
        AppRoutes.onboardingSteps,
      );
    });

    test('authenticated user stays on questionnaire, legal, loading', () {
      expect(
        resolveRedirect(
          location: AppRoutes.onboardingSteps,
          onboardingCompleted: false,
          isAuthenticated: true,
        ),
        isNull,
      );
      expect(
        resolveRedirect(
          location: AppRoutes.onboardingLegal,
          onboardingCompleted: false,
          isAuthenticated: false,
        ),
        isNull,
      );
      expect(
        resolveRedirect(
          location: AppRoutes.onboardingLoading,
          onboardingCompleted: false,
          isAuthenticated: true,
        ),
        isNull,
      );
    });

    test('completed onboarding: onboarding routes bounce home', () {
      expect(
        resolveRedirect(
          location: AppRoutes.onboarding,
          onboardingCompleted: true,
          isAuthenticated: true,
        ),
        AppRoutes.home,
      );
      expect(
        resolveRedirect(
          location: AppRoutes.onboardingForm,
          onboardingCompleted: true,
          isAuthenticated: true,
        ),
        AppRoutes.home,
      );
    });

    test('completed onboarding: auth routes bounce home even when authed', () {
      expect(
        resolveRedirect(
          location: AppRoutes.login,
          onboardingCompleted: true,
          isAuthenticated: true,
        ),
        AppRoutes.home,
      );
    });

    test('completed onboarding, unauthenticated (legacy): login reachable', () {
      expect(
        resolveRedirect(
          location: AppRoutes.login,
          onboardingCompleted: true,
          isAuthenticated: false,
        ),
        isNull,
      );
      expect(
        resolveRedirect(
          location: AppRoutes.home,
          onboardingCompleted: true,
          isAuthenticated: false,
        ),
        isNull,
      );
    });
  });
}
