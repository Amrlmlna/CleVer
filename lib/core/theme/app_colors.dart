import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Monochrome)
  static const Color primaryLight = black; // Black for light theme
  static const Color primaryDark = white; // White for dark theme

  // Greyscale
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey900 = Color(0xFF111827);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey50 = Color(0xFFF9FAFB);

  // Accent Colors (Minimal decorative use only)
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentBlueDark = Color(0xFF1D4ED8);
  static const Color accentBlueLight = Color(0xFF93C5FD);
  static const Color accentCyan = Color(
    0xFF5EEAD4,
  ); // Teal for subtle highlights

  // ─── Profile Section Accent Palette ────────────────────────────────────────
  // Muted pastels for stacked profile cards — each section gets a personality.
  static const Color accentSand = Color(0xFFF5E6D3); // Personal Info
  static const Color accentSage = Color(0xFFE2EDDF); // Experience
  static const Color accentLavender = Color(0xFFE8E0F0); // Education
  static const Color accentMist = Color(0xFFDFE8ED); // Certifications
  static const Color accentLemon = Color(0xFFF0EDD4); // Skills
  static const Color accentPeach = Color(0xFFF8A26A); // Wallet Header
  static const Color accentPeachDark = Color(0xFF8B4A1D); // Wallet Header Text

  // Darker tints for icons/text on accent cards
  static const Color accentSandDark = Color(0xFF8B6914);
  static const Color accentSageDark = Color(0xFF3D6B35);
  static const Color accentLavenderDark = Color(0xFF6B3FA0);
  static const Color accentMistDark = Color(0xFF2E5A6E);
  static const Color accentLemonDark = Color(0xFF6B6520);

  static const Color vibrantPurple = Color(0xFF6344E7);
  static const Color vibrantYellow = Color(0xFFF6C344);
  static const Color vibrantBlack = Color(0xFF1E1E1E);
  static const Color vibrantGreen = Color(0xFFB9D870);
  static const Color vibrantBlue = Color(0xFF44A1F6);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFF59E0B);

  // App Background & Surface
  static const Color backgroundLight = white;
  static const Color backgroundDark = Color(0xFF121212);

  static const Color surfaceLight = white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static const Color borderLight = grey200;
  static const Color borderDark = grey800;

  // ─── Modal / Sheet surfaces ───────────────────────────────────────────────
  // White sheets over a dark app — the high-contrast "action mode" pattern.
  // Change sheetSurface here and every bottom sheet + onboarding panel updates.
  static const Color sheetSurface = white; // Sheet background
  static const Color sheetOnSurface = grey900; // Primary text on sheet
  static const Color sheetOnSurfaceVar = grey500; // Hint / secondary text
  static const Color sheetInputFill = grey100; // Input field fill
  static const Color sheetDivider = grey200; // Dividers & outlineVariant
  static const Color sheetHandle = grey300; // Drag handle pill
}
