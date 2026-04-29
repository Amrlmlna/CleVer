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
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Header ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: colorScheme.error,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    localization.saveChangesTitle.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localization.saveChangesMessage,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ─── Actions ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Save Button (Primary)
                  _DialogButton(
                    onTap: () async {
                      if (onSave != null) await onSave!();
                      if (context.mounted) Navigator.pop(context, true);
                    },
                    label: localization.save,
                    isPrimary: true,
                    icon: Icons.check_circle_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  // Discard Button (Secondary/Alert)
                  _DialogButton(
                    onTap: () async {
                      if (onDiscard != null) await onDiscard!();
                      if (context.mounted) Navigator.pop(context, true);
                    },
                    label: localization.exitWithoutSaving,
                    isPrimary: false,
                    isDanger: true,
                    icon: Icons.delete_outline_rounded,
                  ),
                  const SizedBox(height: 8),
                  // Cancel Button (Tertiary)
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      localization.stayHere.toUpperCase(),
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool isPrimary;
  final bool isDanger;
  final IconData icon;

  const _DialogButton({
    required this.onTap,
    required this.label,
    required this.isPrimary,
    this.isDanger = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bgColor = isPrimary
        ? colorScheme.onSurface
        : (isDanger
              ? colorScheme.error.withValues(alpha: 0.05)
              : Colors.transparent);

    final fgColor = isPrimary
        ? colorScheme.surface
        : (isDanger ? colorScheme.error : colorScheme.onSurface);

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isPrimary
                ? null
                : Border.all(
                    color: isDanger
                        ? colorScheme.error.withValues(alpha: 0.2)
                        : colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: fgColor),
              const SizedBox(width: 10),
              Text(
                label.toUpperCase(),
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: fgColor,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
