import 'package:flutter/material.dart';

class OnboardingCarouselScreen extends StatelessWidget {
  final String headline;
  final String subtext;
  final String? imageAsset;

  const OnboardingCarouselScreen({
    super.key,
    required this.headline,
    required this.subtext,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        if (imageAsset != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: Image.asset(
              imageAsset!,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

        if (imageAsset != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.35, 0.75],
                  colors: [Colors.transparent, colorScheme.surface],
                ),
              ),
            ),
          ),

        if (imageAsset == null)
          Positioned.fill(child: Container(color: colorScheme.surface)),

        Positioned(
          left: 32,
          right: 32,
          bottom: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                headline,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                subtext,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
