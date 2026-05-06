import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cv_generation_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobOutputLanguageSelector extends ConsumerWidget {
  const JobOutputLanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final tailoringOptions = ref.watch(cvCreationProvider).tailoringOptions;
    final value = tailoringOptions.outputLanguage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.language_rounded,
                size: 20,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.cvOutputLanguage,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.cvOutputLanguageDesc,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _buildChip(
                context,
                ref,
                label: l10n.cvOutputLanguageAuto,
                isSelected: value == null,
                onTap: () => _updateLanguage(ref, null),
              ),
              _buildChip(
                context,
                ref,
                label: 'English',
                isSelected: value == 'en',
                onTap: () => _updateLanguage(ref, 'en'),
              ),
              _buildChip(
                context,
                ref,
                label: 'Bahasa',
                isSelected: value == 'id',
                onTap: () => _updateLanguage(ref, 'id'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateLanguage(WidgetRef ref, String? lang) {
    final tailoringOptions = ref.read(cvCreationProvider).tailoringOptions;
    ref
        .read(cvCreationProvider.notifier)
        .setTailoringOptions(
          tailoringOptions.copyWith(outputLanguage: () => lang),
        );
  }

  Widget _buildChip(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.onSurface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.onSurface.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? colorScheme.surface
                  : colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              letterSpacing: isSelected ? 0.5 : 0,
            ),
          ),
        ),
      ),
    );
  }
}
