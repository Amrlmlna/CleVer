import 'package:clever/core/router/app_routes.dart';
import 'package:clever/domain/entities/app_user.dart';
import 'package:clever/domain/entities/user_profile.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:clever/presentation/auth/pages/clever_auth_loading_page.dart';
import 'package:clever/presentation/profile/providers/master_profile_provider.dart';
import 'package:clever/presentation/auth/pages/clever_signup_page.dart';
import 'package:clever/presentation/auth/providers/auth_state_provider.dart';
import 'package:clever/presentation/common/widgets/clever/clever_mascot.dart';
import 'package:clever/presentation/onboarding/pages/clever_get_started_page.dart';
import 'package:clever/presentation/onboarding/pages/clever_welcome_questionnaire_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget materialRouter({
    required GoRouter router,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  GoRouter testRouter({String initialLocation = AppRoutes.onboarding}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const CleverGetStartedPage(),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => const CleverSignupPage(),
        ),
        GoRoute(
          path: AppRoutes.onboardingLoading,
          builder: (context, state) => const CleverAuthLoadingPage(),
        ),
        GoRoute(
          path: AppRoutes.onboardingSteps,
          builder: (context, state) => const CleverWelcomeQuestionnairePage(),
        ),
      ],
    );
  }

  testWidgets('mascot variants compose body and animated face', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SingleChildScrollView(
          child: Column(
            children: const [
              CleverMascot(variant: CleverMascotVariant.getStarted),
              CleverMascot(variant: CleverMascotVariant.signUp),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(LottieBuilder), findsNWidgets(2));
  });

  testWidgets('GetStarted navigates to signup', (tester) async {
    await tester.pumpWidget(materialRouter(router: testRouter()));
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('sign up'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(CleverSignupPage), findsOneWidget);
  });

  testWidgets('signup form validates empty fields', (tester) async {
    final router = testRouter(initialLocation: AppRoutes.signup);
    await tester.pumpWidget(materialRouter(router: router));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('required'), findsNWidgets(2));
  });

  testWidgets('auth loading routes to questionnaire for fresh accounts', (
    tester,
  ) async {
    final router = testRouter(initialLocation: AppRoutes.onboardingLoading);
    await tester.pumpWidget(
      materialRouter(
        router: router,
        overrides: [
          authStateProvider.overrideWith(
            (ref) => Stream.value(const AppUser(uid: 'u1', email: 'a@b.co')),
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(CleverWelcomeQuestionnairePage), findsOneWidget);
  });

  testWidgets('auth loading routes home for accounts with a profile', (
    tester,
  ) async {
    const profile = UserProfile(
      fullName: 'Budi',
      email: 'a@b.co',
      experience: [],
      education: [],
      skills: [],
      certifications: [],
    );

    final router = testRouter(initialLocation: AppRoutes.onboardingLoading);
    await tester.pumpWidget(
      materialRouter(
        router: router,
        overrides: [
          authStateProvider.overrideWith(
            (ref) => Stream.value(const AppUser(uid: 'u1', email: 'a@b.co')),
          ),
          // Seeded profile = established account.
          masterProfileProvider.overrideWith(
            (ref) => MasterProfileNotifier(initialState: profile),
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // completeOnboarding fired and the user landed home (redirect bounces
    // onboarding routes away).
    expect(find.byType(CleverWelcomeQuestionnairePage), findsNothing);
  });
}
