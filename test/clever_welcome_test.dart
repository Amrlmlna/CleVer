import 'dart:convert';

import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:clever/presentation/onboarding/pages/clever_welcome_questionnaire_page.dart';
import 'package:clever/presentation/onboarding/providers/clever_welcome_provider.dart';
import 'package:clever/presentation/onboarding/widgets/clever_welcome/clever_application_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Walks the notifier to the consent step with every answer given.
void seedFinalStep(CleverWelcomeNotifier notifier) {
  notifier
    ..selectPersona(CleverPersona.student)
    ..next()
    ..selectBudget(CleverBudget.under20k)
    ..next()
    ..selectSingleCv(true)
    ..next()
    ..next() // applications-per-day keeps its default
    ..toggleReason(CleverReason.companyResearch)
    ..next()
    ..next(); // social proof
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CleverWelcomeState json round-trip', () {
    test('preserves every field', () {
      const state = CleverWelcomeState(
        step: 4,
        persona: CleverPersona.jobSeeker,
        budget: CleverBudget.around50k,
        hasSingleCv: false,
        applicationsPerDay: 42,
        reasons: {CleverReason.manualTemplate, CleverReason.repeatedForms},
        consented: true,
      );

      final restored = CleverWelcomeState.fromJson(
        jsonDecode(jsonEncode(state.toJson())) as Map<String, dynamic>,
      );

      expect(restored.step, state.step);
      expect(restored.persona, state.persona);
      expect(restored.budget, state.budget);
      expect(restored.hasSingleCv, state.hasSingleCv);
      expect(restored.applicationsPerDay, state.applicationsPerDay);
      expect(restored.reasons, state.reasons);
      expect(restored.consented, state.consented);
    });

    test('falls back to defaults on unknown values', () {
      final restored = CleverWelcomeState.fromJson({
        'step': 'bogus',
        'persona': 'nope',
        'reasons': 'nope',
      });

      expect(restored.step, 0);
      expect(restored.persona, isNull);
      expect(restored.reasons, isEmpty);
    });
  });

  group('CleverWelcomeNotifier gating', () {
    late ProviderContainer container;
    late CleverWelcomeNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(cleverWelcomeProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('cannot advance without answering', () {
      expect(notifier.state.canContinue, isFalse);
      notifier.next();
      expect(notifier.state.step, 0);
    });

    test('advances after answering and steps back', () {
      notifier.selectPersona(CleverPersona.student);
      notifier.next();
      expect(notifier.state.step, 1);
      notifier.back();
      expect(notifier.state.step, 0);
    });

    test('multi-select toggles reasons both ways', () {
      notifier.toggleReason(CleverReason.repromptAi);
      notifier.toggleReason(CleverReason.manualTemplate);
      expect(notifier.state.reasons.length, 2);
      notifier.toggleReason(CleverReason.repromptAi);
      expect(notifier.state.reasons, {CleverReason.manualTemplate});
    });

    test('final step is gated on both consents', () {
      seedFinalStep(notifier);

      expect(notifier.state.step, 6);
      expect(notifier.state.canContinue, isFalse);
      notifier.next();
      expect(notifier.state.step, 6);

      notifier.setConsented(true);
      expect(notifier.state.canContinue, isTrue);
      notifier.next();
      expect(notifier.state.isComplete, isTrue);
    });
  });

  testWidgets('application slider snaps to the three stops', (tester) async {
    int? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CleverApplicationSlider(
            value: 50,
            onChanged: (v) => selected = v,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    final track = tester.getRect(find.byType(SliderTrack));
    await tester.tapAt(Offset(track.left + track.width - 2, track.center.dy));
    await tester.pump(const Duration(milliseconds: 400));
    expect(selected, 100);

    await tester.tapAt(Offset(track.left + 2, track.center.dy));
    await tester.pump(const Duration(milliseconds: 400));
    expect(selected, 10);
  });

  testWidgets('questionnaire page advances and fires onCompleted', (
    tester,
  ) async {
    final seeded = CleverWelcomeNotifier();
    seedFinalStep(seeded);

    var completed = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [cleverWelcomeProvider.overrideWith((ref) => seeded)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CleverWelcomeQuestionnairePage(onCompleted: () => completed++),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('7/8'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.text('read more'), findsOneWidget);

    // Final step's next control is the staging icon-only pill.
    final nextButton = find.ancestor(
      of: find.byIcon(Icons.arrow_outward).last,
      matching: find.byType(ElevatedButton),
    );
    await tester.tap(nextButton);
    await tester.pump(const Duration(milliseconds: 400));
    expect(completed, 0);

    await tester.tap(find.byType(Checkbox));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(nextButton);
    await tester.pump(const Duration(milliseconds: 400));
    expect(completed, 1);
  });
}
