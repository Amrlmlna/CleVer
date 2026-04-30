import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class UnsavedChangesDialog extends StatelessWidget {
  final FutureOr<void> Function()? onSave;
  final FutureOr<void> Function()? onDiscard;

  const UnsavedChangesDialog({super.key, this.onSave, this.onDiscard});

  static Future<bool?> show(
    BuildContext context, {
    FutureOr<void> Function()? onSave,
    FutureOr<void> Function()? onDiscard,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          UnsavedChangesDialog(onSave: onSave, onDiscard: onDiscard),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Minimalist Icon ──────────────────────────────────────
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: Colors.black,
                size: 24,
              ),
            ),
            const SizedBox(height: 24),

            // ─── Text Content ────────────────────────────────────────
            Text(
              localization.saveChangesTitle.toUpperCase(),
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              localization.saveChangesMessage,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.black.withValues(alpha: 0.5),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            // ─── Actions (Industrial Pills) ──────────────────────────
            _IndustrialPillButton(
              onTap: () async {
                if (onSave != null) await onSave!();
                if (context.mounted) Navigator.pop(context, true);
              },
              label: localization.save,
              isPrimary: true,
            ),
            const SizedBox(height: 12),
            _IndustrialPillButton(
              onTap: () async {
                if (onDiscard != null) await onDiscard!();
                if (context.mounted) Navigator.pop(context, true);
              },
              label: localization.exitWithoutSaving,
              isPrimary: false,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                foregroundColor: Colors.black.withValues(alpha: 0.4),
              ),
              child: Text(
                localization.stayHere.toUpperCase(),
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndustrialPillButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool isPrimary;

  const _IndustrialPillButton({
    required this.onTap,
    required this.label,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: double.infinity,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: isPrimary
                ? null
                : Border.all(color: Colors.black, width: 1.5),
          ),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isPrimary ? Colors.white : Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
