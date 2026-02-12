import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import
import '../../../common/widgets/spinning_text_loader.dart'; // Import corrected

class SummarySection extends StatelessWidget {
  final TextEditingController controller;
  final bool isGenerating;
  final VoidCallback onGenerate;
  final bool isDark;

  const SummarySection({
    super.key,
    required this.controller,
    required this.isGenerating,
    required this.onGenerate,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Tulis ringkasan profesional Anda secara singkat...',
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Summary tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: isGenerating ? null : onGenerate,
          // Premium Loading State
          icon: isGenerating 
              ? const SizedBox.shrink() // Hide icon when loading
              : Icon(Icons.auto_awesome, size: 18, color: isDark ? Colors.black : Colors.white),
          label: isGenerating 
              ? SizedBox(
                  height: 20,
                  width: 150, // Fixed width to prevent jitter
                  child: SpinningTextLoader(
                    texts: const ['Thinking...', 'Writing...', 'Polishing...'],
                    style: GoogleFonts.outfit(
                      color: isDark ? Colors.black : Colors.white, 
                      fontWeight: FontWeight.bold,
                    ),
                    interval: const Duration(milliseconds: 1000),
                  ),
                )
              : Text('Generate with AI', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.black,
            foregroundColor: isDark ? Colors.black : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}
