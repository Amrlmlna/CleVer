import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  final String? manualLocaleOverride;
  final Function(String) onLocaleChanged;

  const LanguageSelector({
    super.key,
    required this.manualLocaleOverride,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalLocale = ref.watch(localeNotifierProvider).languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(26),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildLangOption(context, 'en', 'English', globalLocale),
          _buildLangOption(context, 'id', 'Bahasa Indonesia', globalLocale),
        ],
      ),
    );
  }

  Widget _buildLangOption(
    BuildContext context,
    String code,
    String label,
    String globalLocale,
  ) {
    final isSelected = (manualLocaleOverride ?? globalLocale) == code;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: GestureDetector(
        onTap: () => onLocaleChanged(code),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
