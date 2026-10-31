import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'clever_button.dart';

/// Clever-styled confirmation bottom sheet — used instead of dialogs for
/// unsaved-changes and similar confirmations.
class CleverConfirmSheet extends StatelessWidget {
  const CleverConfirmSheet({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.discardLabel,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String discardLabel;

  /// Returns true when the user chose [confirmLabel] (save), false when
  /// discarded, null when dismissed by drag/tap outside.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String discardLabel,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: CleverColors.bgCanvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      builder: (_) => CleverConfirmSheet(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        discardLabel: discardLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 24, 40, 32),
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
              message,
              textAlign: TextAlign.center,
              style: CleverTypography.body.copyWith(
                color: CleverColors.textSecondary,
              ),
            ),
            const SizedBox(height: CleverSpacing.space32),
            CleverButton(
              label: confirmLabel,
              onTap: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: CleverSpacing.space16),
            CleverButton(
              label: discardLabel,
              style: CleverButtonStyle.canvas,
              onTap: () => Navigator.of(context).pop(false),
            ),
            const SizedBox(height: CleverSpacing.space8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(
                l10n.cancel,
                style: CleverTypography.bodyStrong.copyWith(
                  color: CleverColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
