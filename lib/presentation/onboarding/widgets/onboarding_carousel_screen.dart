import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class OnboardingCarouselScreen extends StatelessWidget {
  final String headline;
  final String? subtext;
  final String? imageAsset;
  final Widget? footer;
  final bool isCentered;

  const OnboardingCarouselScreen({
    super.key,
    required this.headline,
    this.subtext,
    this.imageAsset,
    this.footer,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        if (imageAsset != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.6, 1.0],
                  colors: [Colors.white, Colors.transparent],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                imageAsset!,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

        // Deep Vignette
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ),

        // Top/Bottom Fade Gradient
        Positioned(
          top: isCentered ? null : 0,
          bottom: isCentered ? 0 : null,
          left: 0,
          right: 0,
          height: isCentered ? 400 : 200,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: isCentered
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                end: isCentered ? Alignment.topCenter : Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.9),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        if (imageAsset == null)
          Positioned.fill(child: Container(color: Colors.black)),

        Positioned(
          left: 32,
          right: 32,
          top: isCentered ? null : 100,
          bottom: isCentered ? (footer != null ? 180 : 80) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isCentered
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                headline,
                style: AppTextStyles.h1.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                  height: 1.0,
                  letterSpacing: -1.6,
                ),
                textAlign: isCentered ? TextAlign.center : TextAlign.left,
              ),
              if (subtext != null) ...[
                const SizedBox(height: 16),
                Text(
                  subtext!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                    height: 1.5,
                    letterSpacing: -0.2,
                  ),
                  textAlign: isCentered ? TextAlign.center : TextAlign.left,
                ),
              ],
            ],
          ),
        ),

        if (footer != null)
          Positioned(left: 32, right: 32, bottom: 24, child: footer!),
      ],
    );
  }
}
