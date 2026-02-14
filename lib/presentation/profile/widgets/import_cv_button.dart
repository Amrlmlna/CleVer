import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/user_profile.dart';
import '../utils/cv_import_handler.dart';

/// Reusable CV Import Button
/// Shows dialog with Camera/Gallery/PDF options and handles import flow
class ImportCVButton extends ConsumerWidget {
  final Function(UserProfile) onImportSuccess;

  const ImportCVButton({
    super.key,
    required this.onImportSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => CVImportHandler.showImportDialog(
          context: context,
          ref: ref,
          onImportSuccess: onImportSuccess,
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'IMPORT DARI CV',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}
