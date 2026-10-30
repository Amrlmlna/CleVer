import 'package:flutter/material.dart';

/// Motion tokens for screen transitions (300 ms Ease Out in the Figma prototype).
abstract final class CleverMotion {
  static const Duration transition = Duration(milliseconds: 300);
  static const Curve transitionCurve = Curves.easeOut;
}
