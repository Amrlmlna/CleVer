import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../voice_input_pill.dart';
import '../../../../core/theme/app_colors.dart';

class SheetActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String? saveLabel;
  final String? cancelLabel;

  // Optional Voice Input support
  final String? voiceEntityType;
  final OnEntityParsed? onVoiceParsed;

  const SheetActionButtons({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.saveLabel,
    this.cancelLabel,
    this.voiceEntityType,
    this.onVoiceParsed,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          // Cancel Button
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              foregroundColor: AppColors.sheetOnSurfaceVar,
            ),
            child: Text(
              (cancelLabel ?? localization.cancel).toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const Spacer(),

          // Voice Input (Middle)
          if (voiceEntityType != null && onVoiceParsed != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: VoiceInputPill(
                entityType: voiceEntityType!,
                onParsed: onVoiceParsed!,
                isCompact: true,
              ),
            ),

          // Save Button (Right)
          ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              elevation: 0,
            ),
            child: Text(
              saveLabel ?? localization.saveAllCaps,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
