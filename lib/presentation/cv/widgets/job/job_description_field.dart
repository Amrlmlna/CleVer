import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const JobDescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.jobDetailLabel.toUpperCase(),
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface.withValues(alpha: 0.35),
                letterSpacing: 1.5,
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Divider(
                thickness: 1,
                color: colorScheme.onSurface.withValues(alpha: 0.06),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 4,
            minLines: 3,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: l10n.jobDetailHint,
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                height: 1.5,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
