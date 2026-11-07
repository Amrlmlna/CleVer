import 'package:flutter/material.dart';
import 'package:flutter_micro_interactions/flutter_micro_interactions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../profile/utils/cv_import_handler.dart';
import '../../../../domain/entities/user_profile.dart';
import 'clever_scan_sheet.dart';

/// Panel page 1 — method choice ("pilih metode kamu"): scan an old CV or
/// tell the story manually. Reuses the existing import machinery for the
/// actual upload/OCR flow.
class CleverMethodChoiceStep extends ConsumerWidget {
  const CleverMethodChoiceStep({
    super.key,
    required this.onManualEntry,
    required this.onImportSuccess,
  });

  final VoidCallback onManualEntry;
  final Function(UserProfile) onImportSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 33, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.cleverMethodTitle,
            style: CleverTypography.h2.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space16),
          Text(
            l10n.cleverMethodSubtitle,
            style: CleverTypography.bodyStrong.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space32),
          _MethodCard(
            title: l10n.cleverMethodScan,
            description: l10n.cleverMethodScanDesc,
            icon: Icons.document_scanner_outlined,
            onTap: () => _openScanSheet(context, ref),
          ),
          const SizedBox(height: CleverSpacing.space16),
          _MethodCard(
            title: l10n.cleverMethodCerita,
            description: l10n.cleverMethodCeritaDesc,
            icon: Icons.mic_none,
            onTap: onManualEntry,
          ),
        ],
      ),
    );
  }

  void _openScanSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showCleverScanSheet(
      context,
      title: l10n.cleverMethodScan,
      subtitle: l10n.cleverScanSheetSubtitle,
      onPickImage: (source) => CVImportHandler.importFromImage(
        context,
        ref,
        source,
        onImportSuccess,
      ),
      onPickFile: () => CVImportHandler.importFromPDF(context, ref,
          onImportSuccess),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TapFeedback without onTap: its tap-down listener still drives the
    // press animation (it fires optimistically before the arena resolves in
    // the inner InkWell's favour), and it can never double-fire navigation.
    return Material(
      color: Colors.transparent,
      child: TapFeedback.scale(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(CleverRadius.card),
          child: Container(
            padding: const EdgeInsets.all(CleverSpacing.space16),
            decoration: BoxDecoration(
              color: CleverColors.surfaceFieldOnAction,
              borderRadius: BorderRadius.circular(CleverRadius.card),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: CleverTypography.h3.copyWith(
                          color: CleverColors.textOnInverse,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: CleverTypography.bodySm.copyWith(
                          color: CleverColors.textOnInverse,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: CleverSpacing.space16),
                Icon(icon, size: 24, color: CleverColors.textOnInverse),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
