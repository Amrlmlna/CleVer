import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import '../../../common/widgets/spinning_text_loader.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

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
            hintText: AppLocalizations.of(context)!.summaryHint,
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.summaryEmpty;
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: isGenerating ? null : onGenerate,
          icon: isGenerating 
              ? const SizedBox.shrink() 
              : Icon(Icons.auto_awesome, size: 18, color: isDark ? Colors.black : Colors.white),
          label: isGenerating 
              ? SizedBox(
                  height: 20,
                  width: 150, 
                  child: SpinningTextLoader(
                    texts: [
                      AppLocalizations.of(context)!.thinking,
                      AppLocalizations.of(context)!.writing,
                      AppLocalizations.of(context)!.polishing,
                    ],
                    style: GoogleFonts.outfit(
                      color: isDark ? Colors.black : Colors.white, 
                      fontWeight: FontWeight.bold,
                    ),
                    interval: const Duration(milliseconds: 1000),
                  ),
                )
              : Text(AppLocalizations.of(context)!.generateWithAI, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
