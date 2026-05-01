import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../templates/providers/template_provider.dart';

class DeleteAccountVerificationContent extends ConsumerWidget {
  final bool keepLocalData;
  final ValueChanged<bool> onRetentionChanged;

  const DeleteAccountVerificationContent({
    super.key,
    required this.keepLocalData,
    required this.onRetentionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final totalCredits = templatesAsync.maybeWhen(
      data: (templates) =>
          templates.isNotEmpty ? templates.first.userCredits : 0,
      orElse: () => 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.creditBalance.toUpperCase(),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$totalCredits",
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.totalCreditsLabel.toUpperCase(),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (totalCredits > 0) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.creditWarning(totalCredits),
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: SwitchListTile(
            value: keepLocalData,
            onChanged: onRetentionChanged,
            title: Text(
              AppLocalizations.of(context)!.keepLocalData,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.clearLocalData,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            activeThumbColor: colorScheme.primary,
            activeTrackColor: colorScheme.primaryContainer,
          ),
        ),
      ],
    );
  }
}
