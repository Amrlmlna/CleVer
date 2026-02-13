import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'spinning_text_loader.dart';

/// Unified loading screen widget following DRY principle
/// This is the ONLY loading screen you should use across the app
/// 
/// Usage examples:
/// ```dart
/// // OCR Scanning
/// AppLoadingScreen(
///   badge: "OCR SCANNING",
///   messages: ["Membaca gambar...", "Mengekstrak teks..."],
/// )
/// 
/// // CV Generation
/// AppLoadingScreen(
///   badge: "AI PROCESSING",
///   messages: ["Menganalisa Profil...", "Menyusun Struktur..."],
/// )
/// 
/// // Simple loading
/// AppLoadingScreen(
///   messages: ["Loading..."],
/// )
/// ```
class AppLoadingScreen extends StatelessWidget {
  /// Badge text shown at the top (e.g., "AI PROCESSING", "OCR SCANNING")
  /// If null, no badge is shown
  final String? badge;

  /// List of messages that cycle through with animation
  /// Required parameter
  final List<String> messages;

  /// Duration for each message before cycling to the next
  final Duration messageDuration;

  /// Custom text style for the messages
  /// If null, uses default Outfit font
  final TextStyle? messageStyle;

  /// Custom badge style
  /// If null, uses default styling
  final TextStyle? badgeStyle;

  /// Custom badge icon
  /// If null, uses auto_awesome icon
  final IconData? badgeIcon;

  const AppLoadingScreen({
    super.key,
    this.badge,
    required this.messages,
    this.messageDuration = const Duration(milliseconds: 1800),
    this.messageStyle,
    this.badgeStyle,
    this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Optional badge
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark 
                    ? Colors.white.withValues(alpha: 0.1) 
                    : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      badgeIcon ?? Icons.auto_awesome,
                      size: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      badge!,
                      style: badgeStyle ?? GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],

            // Spinning text loader with shimmer effect
            SizedBox(
              height: 40, // Fixed height to prevent layout jumps
              child: SpinningTextLoader(
                texts: messages,
                style: messageStyle ?? GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
                interval: messageDuration,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
