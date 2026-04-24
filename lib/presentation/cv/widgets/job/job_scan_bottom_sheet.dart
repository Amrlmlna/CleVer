import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobScanBottomSheet extends StatelessWidget {
  final Function(ImageSource) onSourceSelected;

  const JobScanBottomSheet({super.key, required this.onSourceSelected});

  static Future<void> show(
    BuildContext context, {
    required Function(ImageSource) onSourceSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          JobScanBottomSheet(onSourceSelected: onSourceSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.scanJobPosting,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _SourceOption(
                  icon: Icons.camera_alt_outlined,
                  label: l10n.camera,
                  onTap: () {
                    Navigator.pop(context);
                    onSourceSelected(ImageSource.camera);
                  },
                ),
                const SizedBox(width: 12),
                _SourceOption(
                  icon: Icons.photo_library_outlined,
                  label: l10n.gallery,
                  onTap: () {
                    Navigator.pop(context);
                    onSourceSelected(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(14),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
          ),
          child: Column(
            children: [
              Icon(icon, color: colorScheme.onSurface, size: 28),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
