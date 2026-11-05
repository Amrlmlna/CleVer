import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Import loading per staging (ImportCVLoading 546:7941 / ImportKHSLoading
/// 546:7986 — identical compositions): "sedang mengimpor" + spinner on cream,
/// the scalloped mascot body bleeding off the bottom with the animated face,
/// and a "batal" text bottom-left that dismisses the screen (the import
/// itself keeps running and reports when done).
///
/// Geometry is taken from the staging node, anchored as fractions of the
/// design surface (402×874) so it scales across devices; the body is
/// bottom-anchored so it always meets the screen edge.
class CleverImportLoadingScreen extends StatelessWidget {
  const CleverImportLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);

    // Design-space fractions (402×874):
    // body SVG 402×651 bottom-anchored; face 241×249 at x68, its top
    // 63.14/650.14 into the body; title y65; spinner 82×77 below; batal
    // x42, 41 above the bottom.
    final bodyHeight = size.width * 651 / 402;
    final faceWidth = size.width * 241 / 402;
    final faceHeight = faceWidth * 249 / 241;
    final faceTopInBodyFraction = 63.143 / 650.143;

    return Scaffold(
      backgroundColor: CleverColors.bgCanvas,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            width: size.width,
            height: bodyHeight,
            child: SvgPicture.asset(
              'assets/ComplexShape/ImportBodyShape.svg',
              width: size.width,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: size.width * 68 / 402,
            bottom: bodyHeight * (1 - faceTopInBodyFraction) - faceHeight,
            width: faceWidth,
            height: faceHeight,
            child: Lottie.asset(
              'assets/Lottie/ImportAnimatedFace.json',
              repeat: true,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 65),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.cleverImportingTitle,
                    style: CleverTypography.h4.copyWith(
                      color: CleverColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 82,
                    height: 77,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      strokeCap: StrokeCap.round,
                      color: CleverColors.surfaceInverse,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 42,
            bottom: 41,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(64, 44),
              ),
              child: Text(
                l10n.cancel,
                style: CleverTypography.h4.copyWith(
                  color: CleverColors.textOnDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
