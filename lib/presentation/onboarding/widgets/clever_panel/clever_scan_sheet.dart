import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// The shared "scan a document" source chooser per staging: drag handle,
/// centred title + subtitle, then the two upload cards (photo / file).
/// "upload photo" fans out into a camera / gallery sub-sheet. Both the CV
/// import (method choice) and the KHS scan (education) open this sheet.
Future<void> showCleverScanSheet(
  BuildContext context, {
  required String title,
  required String subtitle,
  required ValueChanged<ImageSource> onPickImage,
  required VoidCallback onPickFile,
}) {
  final l10n = AppLocalizations.of(context)!;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: CleverColors.bgCanvas,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(CleverRadius.sheet),
      ),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 23, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 47,
                height: 4,
                decoration: BoxDecoration(
                  color: CleverColors.surfaceInverse.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: CleverSpacing.space24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: CleverTypography.h3.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
            const SizedBox(height: CleverSpacing.space8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: CleverTypography.bodyStrong.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
            const SizedBox(height: CleverSpacing.space24),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CleverUploadCard(
                      icon: Icons.add_photo_alternate_outlined,
                      label: l10n.cleverUploadPhoto,
                      hint: l10n.cleverUploadPhotoHint,
                      onTap: () {
                        Navigator.pop(sheetContext);
                        _pickPhoto(context, onPickImage);
                      },
                    ),
                  ),
                  const SizedBox(width: CleverSpacing.space16),
                  Expanded(
                    child: CleverUploadCard(
                      icon: Icons.upload_file_outlined,
                      label: l10n.cleverUploadFile,
                      hint: l10n.cleverUploadFileHint,
                      onTap: () {
                        Navigator.pop(sheetContext);
                        onPickFile();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// "Unggah foto" covers both camera and gallery — the staging copy names
/// both sources under one card.
void _pickPhoto(BuildContext context, ValueChanged<ImageSource> onPickImage) {
  final l10n = AppLocalizations.of(context)!;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: CleverColors.bgCanvas,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(CleverRadius.sheet),
      ),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 23, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CleverSourceRow(
              icon: Icons.photo_camera_outlined,
              label: l10n.camera,
              onTap: () {
                Navigator.pop(sheetContext);
                onPickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: CleverSpacing.space12),
            CleverSourceRow(
              icon: Icons.photo_library_outlined,
              label: l10n.gallery,
              onTap: () {
                Navigator.pop(sheetContext);
                onPickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class CleverUploadCard extends StatelessWidget {
  const CleverUploadCard({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Container(
          padding: const EdgeInsets.all(CleverSpacing.space16),
          decoration: BoxDecoration(
            border: Border.all(
              color: CleverColors.surfaceInverse,
              width: CleverStrokes.hairline,
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            children: [
              Icon(icon, size: 26, color: CleverColors.surfaceInverse),
              const SizedBox(height: CleverSpacing.space8),
              Text(
                label,
                style: CleverTypography.bodyStrong.copyWith(
                  color: CleverColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hint,
                textAlign: TextAlign.center,
                style: CleverTypography.caption.copyWith(
                  color: CleverColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CleverSourceRow extends StatelessWidget {
  const CleverSourceRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(CleverRadius.card),
        child: Container(
          padding: const EdgeInsets.all(CleverSpacing.space16),
          decoration: BoxDecoration(
            color: CleverColors.surfaceSelected,
            borderRadius: BorderRadius.circular(CleverRadius.card),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: CleverColors.surfaceInverse),
              const SizedBox(width: CleverSpacing.space16),
              Expanded(
                child: Text(
                  label,
                  style: CleverTypography.bodyStrong.copyWith(
                    color: CleverColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                size: 18,
                color: CleverColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
