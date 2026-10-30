import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type scale mirroring the Figma `Clever / Type` collection. Letter spacing
/// is Figma's percentage tracking applied to each font size. Styles carry no
/// color; apply a [CleverColors] text token at the usage site.
abstract final class CleverTypography {
  static TextStyle get display => _style(48, 52, FontWeight.w600, -1.44);
  static TextStyle get h1 => _style(36, 40, FontWeight.w600, -1.08);
  static TextStyle get h2 => _style(32, 36, FontWeight.w600, -0.96);
  static TextStyle get h3 => _style(24, 28, FontWeight.w600, -0.48);
  static TextStyle get h4 => _style(20, 24, FontWeight.w600, -0.4);
  static TextStyle get body => _style(16, 24, FontWeight.w400, -0.16);
  static TextStyle get bodyStrong => _style(16, 24, FontWeight.w600, -0.16);
  static TextStyle get bodySm => _style(15, 22, FontWeight.w400, -0.15);
  static TextStyle get label => _style(14, 20, FontWeight.w500, 0);
  static TextStyle get caption => _style(12, 16, FontWeight.w400, 0);
  static TextStyle get micro => _style(11, 14, FontWeight.w500, 0);
  static TextStyle get numeral => _style(150, 150, FontWeight.w600, -7.5);

  static TextStyle _style(
    double fontSize,
    double lineHeight,
    FontWeight fontWeight,
    double letterSpacing,
  ) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      height: lineHeight / fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );
  }
}
