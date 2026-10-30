import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

void main() {
  testWidgets('mascot face Lottie assets parse, render, and run their loops', (
    tester,
  ) async {
    const exports = {
      'assets/Lottie/GetStartedScreenAnimatedFace.json': Duration(
        seconds: 5,
        milliseconds: 33,
      ),
      'assets/Lottie/SignUpFormAnimatedFace.json': Duration(seconds: 5),
      'assets/Lottie/SignInFormAuthLoadingAnimatedFace.json': Duration(
        seconds: 5,
        milliseconds: 533,
      ),
    };

    for (final entry in exports.entries) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Lottie.asset(entry.key, repeat: true)),
        ),
      );
      await tester.pump();
      expect(find.byType(LottieBuilder), findsOneWidget, reason: entry.key);

      final composition = await AssetLottie(entry.key).load();
      expect(composition.duration, entry.value, reason: entry.key);
    }
  });

  testWidgets('mascot body SVG parses and renders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SvgPicture.asset(
            'assets/ComplexShape/BodyShape - SignInUp - WelcomeStep7 - AuthLoading.svg',
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
