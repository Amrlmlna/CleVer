import 'package:clever/presentation/common/widgets/clever/clever_button.dart';
import 'package:clever/presentation/common/widgets/clever/clever_divider.dart';
import 'package:clever/presentation/common/widgets/clever/clever_google_button.dart';
import 'package:clever/presentation/common/widgets/clever/clever_nav_action_bar.dart';
import 'package:clever/presentation/common/widgets/clever/clever_option_tile.dart';
import 'package:clever/presentation/common/widgets/clever/clever_progress_bar.dart';
import 'package:clever/presentation/common/widgets/clever/clever_sheet.dart';
import 'package:clever/presentation/common/widgets/clever/clever_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('CleverButton renders label and fires onTap in every style', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        Column(
          children: [
            for (final style in CleverButtonStyle.values)
              CleverButton(label: 'lanjut', style: style, onTap: () => taps++),
          ],
        ),
      ),
    );
    expect(find.text('lanjut'), findsNWidgets(3));
    await tester.tap(find.byType(CleverButton).first);
    expect(taps, 1);
  });

  testWidgets('CleverButton builds disabled', (tester) async {
    await tester.pumpWidget(wrap(const CleverButton(label: 'lanjut')));
    expect(find.text('lanjut'), findsOneWidget);
  });

  testWidgets('CleverGoogleButton builds and fires onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        Center(
          child: CleverGoogleButton(
            label: 'Daftar dengan Google',
            onTap: () => taps++,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(CleverGoogleButton));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('CleverTextField accepts input and toggles obscure', (
    tester,
  ) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      wrap(
        CleverTextField(
          hintText: 'password',
          controller: controller,
          obscureText: true,
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'secret');
    expect(controller.text, 'secret');
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('CleverTextField validator surfaces error on every surface', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpWidget(
      wrap(
        Form(
          key: formKey,
          child: Column(
            children: [
              for (final surface in CleverFieldSurface.values)
                CleverTextField(
                  hintText: 'x',
                  surface: surface,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'wajib diisi' : null,
                ),
            ],
          ),
        ),
      ),
    );
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('wajib diisi'), findsNWidgets(4));
  });

  testWidgets('CleverNavActionBar tones build and fire callbacks', (
    tester,
  ) async {
    var back = 0;
    var next = 0;
    await tester.pumpWidget(
      wrap(
        Column(
          children: [
            for (final tone in CleverNavTone.values)
              CleverNavActionBar(
                tone: tone,
                backLabel: 'kembali',
                onBack: () => back++,
                onNext: () => next++,
              ),
            CleverNavActionBar(onBack: () => back++, onNext: () => next++),
          ],
        ),
      ),
    );
    expect(find.text('kembali'), findsNWidgets(3));
    await tester.tap(find.byType(TextButton).first);
    expect(back, 1);
    await tester.tap(find.byIcon(Icons.arrow_outward).first);
    expect(next, 1);
  });

  testWidgets('CleverProgressBar shows step counter', (tester) async {
    await tester.pumpWidget(wrap(const CleverProgressBar(index: 3, total: 8)));
    expect(find.text('3/8'), findsOneWidget);
  });

  testWidgets('CleverOptionTile fires onTap in both states', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        Column(
          children: [
            CleverOptionTile(
              label: 'pelajar',
              trailingIcon: Icons.thumb_up_outlined,
              onTap: () => taps++,
            ),
            CleverOptionTile(
              label: 'berpindah karir',
              selected: true,
              onTap: () => taps++,
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('pelajar'));
    await tester.tap(find.text('berpindah karir'));
    expect(taps, 2);
  });

  testWidgets('CleverSheet with handle and CleverDivider build', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const CleverSheet(
          showHandle: true,
          child: CleverDivider(label: 'atau'),
        ),
      ),
    );
    expect(find.text('atau'), findsOneWidget);
    expect(find.byType(CleverSheet), findsOneWidget);
  });
}
