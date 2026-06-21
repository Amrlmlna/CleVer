import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clever/presentation/common/widgets/app_loading_screen.dart';

void main() {
  testWidgets('AppLoadingScreen shows badge and loading messages', (
    WidgetTester tester,
  ) async {
    // Build AppLoadingScreen inside MaterialApp.
    await tester.pumpWidget(
      const MaterialApp(
        home: AppLoadingScreen(
          badge: 'TESTING BADGE',
          messages: ['Loading data...', 'Processing data...'],
        ),
      ),
    );

    // Verify that the badge is displayed.
    expect(find.text('TESTING BADGE'), findsOneWidget);

    // Verify that the first loading message is displayed.
    expect(find.text('Loading data...'), findsOneWidget);
  });
}
