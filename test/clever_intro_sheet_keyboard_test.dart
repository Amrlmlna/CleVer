import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:clever/presentation/onboarding/pages/clever_career_bank_intro_page.dart';

/// Regression: the panel sheet positions against viewInsets, so closing or
/// dragging it while the keyboard is open used to invert its height
/// (top near screenH, bottom = keyboard inset) and squeeze the panel steps
/// into a near-zero box — RenderFlex overflowed by 124px in the header step.
/// The sheet now drops the keyboard on drag start / close, clamps the inset
/// to its own height, and renders nothing at all while fully closed.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Opening the sheet fires a PostHog capture; the platform channel has no
  // handler under tests — mock it so the fire-and-forget call is a no-op.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('posthog_flutter'),
    (call) async => null,
  );

  final inset = ValueNotifier<double>(0.0);

  Future<void> pumpIntro(WidgetTester tester) async {
    // A realistic phone surface — the default 800×600 test window is shorter
    // than any real device, which would confound the sheet-height math.
    tester.view.physicalSize = const Size(822, 1800);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ValueListenableBuilder<double>(
        valueListenable: inset,
        builder: (context, value, _) => MediaQuery(
          data: MediaQueryData.fromView(View.of(context)).copyWith(
            viewInsets: EdgeInsets.only(bottom: value),
          ),
          child: MaterialApp(
            locale: const Locale('id'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ProviderScope(
              child: Scaffold(
                body: CleverCareerBankIntroPage(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('closing the sheet under an open keyboard never overflows', (
    tester,
  ) async {
    await pumpIntro(tester);

    // Open the panel sheet.
    await tester.tap(find.text('mulai sekarang'));
    await tester.pumpAndSettle();
    expect(find.text('header'), findsOneWidget);

    // Keyboard appears (the user focused a field).
    inset.value = 300;
    await tester.pump();

    // Drag the sheet down ~150px, slowly (below the fling threshold and
    // staying above the t<0.5 close threshold so it springs back): the old
    // code hit height = 0.9·t·screenH − 300 < header content and overflowed.
    await tester.timedDrag(
      find.text('header'),
      const Offset(0, 150),
      const Duration(milliseconds: 900),
    );
    await tester.pump();

    // It springs back open (drag below the close threshold)...
    await tester.pumpAndSettle();
    expect(find.text('header'), findsOneWidget);

    // ...and now closes all the way under the same keyboard — the reverse
    // animation passes through every collapsed-height frame.
    await tester.drag(find.text('header'), const Offset(0, 800));
    await tester.pumpAndSettle();

    // Sheet fully closed and the intro back in front.
    expect(find.text('header'), findsNothing);
    expect(find.text('mulai sekarang'), findsOneWidget);
  });

  testWidgets('sheet renders nothing while fully closed', (tester) async {
    await pumpIntro(tester);

    // Closed + keyboard up: the old Positioned(top: screenH, bottom: inset)
    // laid out an inverted box that painted an orange sliver at the bottom.
    inset.value = 300;
    await tester.pump();

    expect(find.text('header'), findsNothing);
    // The intro itself is still interactive.
    expect(find.text('mulai sekarang'), findsOneWidget);
  });
}
