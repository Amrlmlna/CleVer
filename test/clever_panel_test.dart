import 'dart:convert';

import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:clever/presentation/onboarding/providers/onboarding_provider.dart';
import 'package:clever/presentation/onboarding/widgets/clever_panel/clever_header_step.dart';
import 'package:clever/presentation/profile/widgets/experience_bottom_sheet.dart';
import 'package:clever/presentation/onboarding/widgets/clever_panel/clever_experience_step.dart';
import 'package:clever/presentation/onboarding/widgets/clever_panel/clever_method_choice_step.dart';
import 'package:clever/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('panel draft persistence', () {
    test('state round-trips through json', () {
      final state = OnboardingState(
        currentPage: 2,
        formData: UserProfile(
          fullName: 'Budi',
          email: 'budi@mail.id',
          phoneNumber: '0812',
          birthDate: '2001-01-22T00:00:00.000',
          gender: 'male',
          experience: [],
          education: [],
          skills: [],
          certifications: [],
        ),
      );

      final restored = OnboardingState.fromJson(
        jsonDecode(jsonEncode(state.toJson())) as Map<String, dynamic>,
      );

      expect(restored.currentPage, 2);
      expect(restored.formData.fullName, 'Budi');
      expect(restored.formData.phoneNumber, '0812');
      expect(restored.formData.gender, 'male');
    });

    test('hasAnyData reflects user input', () {
      final empty = OnboardingState(
        currentPage: 0,
        formData: UserProfile(
          fullName: '',
          email: '',
          experience: [],
          education: [],
          skills: [],
          certifications: [],
        ),
      );
      expect(empty.hasAnyData, isFalse);

      expect(
        empty
            .copyWith(formData: empty.formData.copyWith(fullName: 'Budi'))
            .hasAnyData,
        isTrue,
      );
      expect(
        empty
            .copyWith(formData: empty.formData.copyWith(gender: 'male'))
            .hasAnyData,
        isTrue,
      );
    });

    test('notifier persists a draft that a fresh notifier restores', () async {
      final writer = ProviderContainer();
      writer.listen(onboardingFormProvider, (_, __) {});
      addTearDown(writer.dispose);
      final notifier = writer.read(onboardingFormProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      notifier.updateName('Budi');
      notifier.updateGender('male');
      await Future<void>.delayed(Duration.zero);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('onboarding_form_draft'), isNotNull);

      final reader = ProviderContainer();
      reader.listen(onboardingFormProvider, (_, __) {});
      addTearDown(reader.dispose);
      final restored = reader.read(onboardingFormProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      expect(restored.state.formData.fullName, 'Budi');
      expect(restored.state.formData.gender, 'male');
    });

    test('discardDraft resets state and clears storage', () async {
      final container = ProviderContainer();
      container.listen(onboardingFormProvider, (_, __) {});
      addTearDown(container.dispose);
      final notifier = container.read(onboardingFormProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      notifier.updateName('Budi');
      await Future<void>.delayed(Duration.zero);
      await notifier.discardDraft();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('onboarding_form_draft'), isNull);
      expect(container.read(onboardingFormProvider).hasAnyData, isFalse);
    });
  });

  group('CleverHeaderStep', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      container.listen(onboardingFormProvider, (_, __) {});
    });

    tearDown(() => container.dispose());

    testWidgets('requires a name before advancing', (tester) async {
      var advanced = 0;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('id'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: CleverHeaderStep(onNext: () => advanced++)),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('lanjut'));
      await tester.pump();
      expect(advanced, 0);

      await tester.enterText(find.byType(TextFormField).first, 'Budi');
      await tester.pump();
      expect(container.read(onboardingFormProvider).formData.fullName, 'Budi');

      await tester.tap(find.text('lanjut'));
      await tester.pump();
      expect(advanced, 1);
    });

    testWidgets('gender chips write stable ids into the form state', (
      tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('id'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: CleverHeaderStep(onNext: () {})),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text('wanita'));
      await tester.pump();
      expect(container.read(onboardingFormProvider).formData.gender, 'female');
    });
  });

  group('CleverMethodChoiceStep', () {
    testWidgets('cerita card advances to manual entry', (tester) async {
      var manual = false;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CleverMethodChoiceStep(
              onManualEntry: () => manual = true,
              onImportSuccess: (_) {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('cerita'));
      await tester.pump();
      expect(manual, isTrue);
    });

    testWidgets('scan card opens the upload sheet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CleverMethodChoiceStep(
              onManualEntry: () {},
              onImportSuccess: (_) {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('scan'));
      await tester.pumpAndSettle();
      expect(find.text('unggah foto'), findsOneWidget);
      expect(find.text('unggah file'), findsOneWidget);
    });
  });

  group('CleverExperienceStep', () {
    testWidgets('empty state shows dynamic skip label and opens add sheet', (
      tester,
    ) async {
      final container = ProviderContainer();
      container.listen(onboardingFormProvider, (_, __) {});
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('id'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: CleverExperienceStep(onNext: () {})),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('masih kosong nih'), findsOneWidget);
      expect(find.text('lewati'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(ExperienceBottomSheet), findsOneWidget);
    });

    testWidgets('non-empty state lists entries with lanjut label', (
      tester,
    ) async {
      final container = ProviderContainer();
      container.listen(onboardingFormProvider, (_, __) {});
      addTearDown(container.dispose);
      container.read(onboardingFormProvider.notifier).updateExperience([
        const Experience(
          id: '1',
          jobTitle: 'software engineer',
          description: 'built things',
          companyName: 'Google',
          startDate: '2021 - sekarang',
        ),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('id'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: CleverExperienceStep(onNext: () {})),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('software engineer'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('lewati'), findsNothing);
      expect(find.text('lanjut'), findsOneWidget);
    });
  });
}
