import 'package:flutter/material.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Gender selection chips ("pria" / "wanita" / "none"). Stores stable ids
/// ('male' / 'female' / 'none') — labels are localized at the edge.
class CleverGenderChips extends StatelessWidget {
  const CleverGenderChips({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = {
      'male': l10n.cleverGenderMale,
      'female': l10n.cleverGenderFemale,
      'none': l10n.cleverGenderNone,
    };

    return Row(
      children: [
        for (final entry in options.entries) ...[
          _Chip(
            label: entry.value,
            selected: selected == entry.key,
            onTap: () => onSelect(entry.key),
          ),
          if (entry.key != options.keys.last)
            const SizedBox(width: CleverSpacing.space12),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (fill, foreground) = selected
        ? (CleverColors.surfaceFieldOnAction, CleverColors.textOnDark)
        : (CleverColors.bgCanvas, CleverColors.textPrimary);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CleverRadius.field),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: CleverSpacing.space16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(CleverRadius.field),
        ),
        child: Text(
          label,
          style: CleverTypography.bodyStrong.copyWith(color: foreground),
        ),
      ),
    );
  }
}
