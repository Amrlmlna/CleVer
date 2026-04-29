import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobScanBottomSheet extends StatelessWidget {
  final Function(ImageSource) onImageSelected;
  final VoidCallback onPdfSelected;

  const JobScanBottomSheet({
    super.key,
    required this.onImageSelected,
    required this.onPdfSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(ImageSource) onImageSelected,
    required VoidCallback onPdfSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => JobScanBottomSheet(
        onImageSelected: onImageSelected,
        onPdfSelected: onPdfSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              l10n.scanJobPosting.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.jobListScannerHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),

            _buildOption(
              context: context,
              icon: Icons.camera_alt_rounded,
              label: l10n.camera,
              onTap: () {
                Navigator.pop(context);
                onImageSelected(ImageSource.camera);
              },
            ),
            _buildOption(
              context: context,
              icon: Icons.photo_library_rounded,
              label: l10n.gallery,
              onTap: () {
                Navigator.pop(context);
                onImageSelected(ImageSource.gallery);
              },
            ),
            _buildOption(
              context: context,
              icon: Icons.picture_as_pdf_rounded,
              label: l10n.pdfFile,
              onTap: () {
                Navigator.pop(context);
                onPdfSelected();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.colorScheme.onSurface, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
