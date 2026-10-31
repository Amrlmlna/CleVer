import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';

/// The InputStep1 UFO illustration: a beam of job tags shooting down from
/// the UFO. Geometry and fades come from the exported source SVG
/// (docs/redesign/assets-source/UFO.svg, viewBox 402×419).
class CleverUfoIllustration extends StatelessWidget {
  const CleverUfoIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 402,
      height: 419,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: _BeamClipper(),
            child: Stack(
              children: [
                Positioned(
                  left: -44.93,
                  top: -168.89,
                  child: Image.asset(
                    'assets/images/ufo_tags.png',
                    width: 444.66,
                    fit: BoxFit.fill,
                  ),
                ),
                // The beam's alpha mask fades to transparent at the bottom.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.55, 1.0],
                        colors: [
                          CleverColors.bgCanvas.withValues(alpha: 0),
                          CleverColors.bgCanvas,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 145.53,
            top: 0,
            child: Image.asset('assets/images/ufo_icon.png', width: 109.18),
          ),
        ],
      ),
    );
  }
}

class _BeamClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(199.69, 32.92)
      ..lineTo(423.29, 415)
      ..lineTo(-28, 415)
      ..close();
  }

  @override
  bool shouldReclip(_BeamClipper oldClipper) => false;
}
