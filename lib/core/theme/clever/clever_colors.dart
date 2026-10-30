import 'package:flutter/material.dart';

import 'clever_palette.dart';

/// Semantic colors mirroring the Figma `Clever / Semantic` collection.
abstract final class CleverColors {
  static const Color bgCanvas = CleverPalette.vanilla;
  static const Color bgOnboarding = CleverPalette.royalBlue;
  static const Color bgAction = CleverPalette.orange;
  static const Color bgSuccess = CleverPalette.forest;
  static const Color bgAi = CleverPalette.plum;
  static const Color bgDanger = CleverPalette.wineRed;

  static const Color surfaceRaised = CleverPalette.milk;
  static const Color surfaceField = CleverPalette.orangeTint;
  static const Color surfaceFieldOnAction = CleverPalette.orangeSurface;
  static const Color surfaceSelected = CleverPalette.vanillaSurface;
  static const Color surfaceOnDark = CleverPalette.lightCream;
  static const Color surfaceInsetOnDark = CleverPalette.lightSand;
  static const Color surfaceSuccess = CleverPalette.leaf;
  static const Color surfaceInverse = CleverPalette.midnight;

  static const Color textPrimary = CleverPalette.midnight;
  static const Color textSecondary = CleverPalette.textSecondary;
  static const Color textAccent = CleverPalette.orangeInk;
  static const Color textOnDark = CleverPalette.lightCream;
  static const Color textOnAction = CleverPalette.midnight;
  static const Color textDanger = CleverPalette.wineRed;
  static const Color textSuccess = CleverPalette.forest;
  static const Color textLink = CleverPalette.royalBlue;
  static const Color textOnInverse = CleverPalette.vanilla;

  static const Color borderSubtle = CleverPalette.borderSubtle;

  static const Color stateDisabled = Color.fromRGBO(40, 43, 74, 0.38);
  static const Color scrim = Color.fromRGBO(40, 43, 74, 0.60);
}
