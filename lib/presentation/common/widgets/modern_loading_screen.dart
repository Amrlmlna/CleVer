import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import
import 'shimmer_text.dart';
import 'spinning_text_loader.dart';

class ModernLoadingScreen extends StatelessWidget {
  const ModernLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark mode check (though we might force dark mode in this app)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating "AI" Badge or similar minimalist icon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: isDark ? Colors.white70 : Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    "AI PROCESSING",
                    style: GoogleFonts.outfit(
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

            // Spinning Text Loader (The "Lottery Machine" effect)
            SizedBox(
              height: 40, // Fixed height to prevent layout jumps
              child: SpinningTextLoader(
                texts: const [
                  "Menganalisa Profil...",
                  "Menyusun Struktur...",
                  "Menulis Summary...",
                  "Memoles Tata Letak...",
                  "Finalisasi Dokumen..."
                ],
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w300, 
                  color: textColor,
                ),
                interval: const Duration(milliseconds: 1800),
              ),
            ),
            
            const SizedBox(height: 16),

            // Shimmering Status text
            ShimmerText(
              text: "Generating your perfect CV...",
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: Colors.grey, 
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
