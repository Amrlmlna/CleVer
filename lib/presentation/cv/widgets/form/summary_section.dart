import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class SummarySection extends StatelessWidget {
  final TextEditingController controller;

  const SummarySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.summaryHint,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.summaryEmpty;
            }
            return null;
          },
        ),
      ],
    );
  }
}
