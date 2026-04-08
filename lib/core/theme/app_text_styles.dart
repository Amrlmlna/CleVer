import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Headings
  /// FontSize: 32, Weight: bold
  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      );

  /// FontSize: 28, Weight: w700
  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  /// FontSize: 24, Weight: w600
  static TextStyle get h3 => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      );

  /// FontSize: 20, Weight: w600
  static TextStyle get h4 => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  /// FontSize: 18, Weight: normal
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.normal,
      );

  /// FontSize: 16, Weight: normal
  static TextStyle get body => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );
      
  /// FontSize: 14, Weight: normal
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  /// FontSize: 12, Weight: normal
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  /// FontSize: 14, Weight: w600
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  /// FontSize: 12, Weight: w500
  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  /// FontSize: 10, Weight: w500
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );
}
