import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

void main() {
  testWidgets('GetStarted face Lottie asset parses and renders', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Lottie.asset(
            'assets/Lottie/GetStartedScreenAnimatedFace.json',
            repeat: true,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(LottieBuilder), findsOneWidget);

    final composition = await AssetLottie(
      'assets/Lottie/GetStartedScreenAnimatedFace.json',
    ).load();
    expect(composition.duration, const Duration(seconds: 5, milliseconds: 33));
  });
}
