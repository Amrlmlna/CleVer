import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const JobDescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.jobDetailLabel,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 5,
            style: GoogleFonts.inter(
              color: colorScheme.onSurface,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.jobDetailHint,
              hintStyle: GoogleFonts.inter(
                color: colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
