import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_profile.dart';
import '../utils/cv_import_handler.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class ImportCVButton extends ConsumerWidget {
  final Function(UserProfile) onImportSuccess;

  const ImportCVButton({super.key, required this.onImportSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () => CVImportHandler.showImportDialog(
        context: context,
        ref: ref,
        onImportSuccess: onImportSuccess,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.importFromCV.toUpperCase(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  height: 1.0,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_rounded,
                size: 24,
                weight: 800,
                color: theme.colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
