import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/clever/clever_colors.dart';

enum CleverMascotVariant {
  getStarted,
  signUp,
  signIn,
  authLoading,
  welcomeStep7,
}

/// Composes the mascot from exported assets: static body layers plus the
/// face (animated Lottie, or the static PNG for welcomeStep7). Every
/// geometry value below is taken from the Figma staging nodes or the
/// exported body SVG (402×766, mascot-box local).
class CleverMascot extends StatelessWidget {
  const CleverMascot({super.key, required this.variant});

  final CleverMascotVariant variant;

  static const _faceAssets = {
    CleverMascotVariant.getStarted:
        'assets/Lottie/GetStartedScreenAnimatedFace.json',
    CleverMascotVariant.signUp: 'assets/Lottie/SignUpFormAnimatedFace.json',
    CleverMascotVariant.signIn:
        'assets/Lottie/SignInFormAuthLoadingAnimatedFace.json',
    CleverMascotVariant.authLoading:
        'assets/Lottie/SignInFormAuthLoadingAnimatedFace.json',
  };

  /// Step 7's mascot is static: shared body plus the exported face PNG.
  static const _step7FaceAsset = 'assets/Lottie/WelcomeStep7StaticMascot.png';

  Size get _boxSize => switch (variant) {
    CleverMascotVariant.getStarted => const Size(518, 632),
    CleverMascotVariant.signUp => const Size(458, 685),
    CleverMascotVariant.signIn => const Size(485, 685),
    CleverMascotVariant.authLoading => const Size(485, 767),
    CleverMascotVariant.welcomeStep7 => const Size(485, 736),
  };

  /// Horizontal position of the mascot box on its screen; the shared body
  /// SVG was exported in screen space, so body layers shift by this amount.
  double get _bodyShift => switch (variant) {
    CleverMascotVariant.signUp => -(-56.0),
    CleverMascotVariant.signIn => -(-58.0),
    CleverMascotVariant.authLoading => -(-56.0),
    CleverMascotVariant.welcomeStep7 => -(-67.0),
    CleverMascotVariant.getStarted => 0,
  };

  // TODO(figma): face offsets for signUp/signIn/authLoading are estimates
  // pending a Figwright session; getStarted is the exact staging value.
  Offset get _faceOffset => switch (variant) {
    CleverMascotVariant.getStarted => const Offset(224.9, 90.9),
    CleverMascotVariant.signUp => const Offset(125, 64),
    CleverMascotVariant.signIn => const Offset(162, 137),
    CleverMascotVariant.authLoading => const Offset(162, 153),
    CleverMascotVariant.welcomeStep7 => const Offset(122, 199),
  };

  double get _faceWidth => switch (variant) {
    CleverMascotVariant.getStarted => 170.8,
    CleverMascotVariant.signUp => 207.4,
    CleverMascotVariant.signIn => 160,
    CleverMascotVariant.authLoading => 160,
    CleverMascotVariant.welcomeStep7 => 193,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _boxSize.width,
      height: _boxSize.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (variant == CleverMascotVariant.getStarted)
            ..._getStartedBody()
          else
            ..._sharedBody(),
          Positioned(
            left: _faceOffset.dx,
            top: _faceOffset.dy,
            child: variant == CleverMascotVariant.welcomeStep7
                ? Image.asset(_step7FaceAsset, width: _faceWidth)
                : Lottie.asset(
                    _faceAssets[variant]!,
                    width: _faceWidth,
                    repeat: true,
                    filterQuality: FilterQuality.medium,
                  ),
          ),
        ],
      ),
    );
  }

  /// GetStarted head: rounded rect (523×714, r132 at x −2.5) + sheen
  /// gradient over the lower body. Ear ellipses pending exact Figma
  /// positions (TODO(figma)).
  List<Widget> _getStartedBody() {
    return [
      Positioned(
        left: -2.5,
        top: 0,
        child: Container(
          width: 523,
          height: 714,
          decoration: BoxDecoration(
            color: CleverColors.surfaceInverse,
            borderRadius: BorderRadius.circular(132),
          ),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        height: 507,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                CleverColors.bgOnboarding.withValues(alpha: 0),
                CleverColors.bgOnboarding,
              ],
            ),
          ),
        ),
      ),
    ];
  }

  /// Shared body for signUp/signIn/authLoading/welcomeStep7, from the
  /// exported SVG: scallop band (−56,0 485×209), midnight block (0,157
  /// 419×629), sheen gradient (−19,25 431×751, painted bottom-up).
  List<Widget> _sharedBody() {
    Widget layer(
      double left,
      double top,
      double width,
      double height,
      Decoration decoration,
    ) {
      return Positioned(
        left: left + _bodyShift,
        top: top,
        child: SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(decoration: decoration),
        ),
      );
    }

    return [
      layer(
        0,
        157,
        419,
        629,
        const BoxDecoration(color: CleverColors.surfaceInverse),
      ),
      layer(
        -56,
        0,
        485,
        209,
        const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ComplexShape/scallop_band.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
      layer(
        -19,
        25,
        431,
        751,
        BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CleverColors.bgOnboarding.withValues(alpha: 0),
              CleverColors.bgOnboarding.withValues(alpha: 0.9),
            ],
          ),
        ),
      ),
    ];
  }
}
