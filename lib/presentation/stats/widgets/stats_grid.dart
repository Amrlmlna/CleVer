import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class StatsGrid extends StatelessWidget {
  final Map<String, int> stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final items = [
      {
        'label': AppLocalizations.of(context)!.totalCVs,
        'value': stats['cvCount'].toString(),
        'icon': Icons.description_outlined,
      },
      {
        'label': AppLocalizations.of(context)!.skills,
        'value': stats['skillsCount'].toString(),
        'icon': Icons.bolt_outlined,
      },
      {
        'label': AppLocalizations.of(context)!.experience,
        'value': stats['experienceCount'].toString(),
        'icon': Icons.work_outline,
      },
      {
        'label': AppLocalizations.of(context)!.educationHistory,
        'value': stats['educationCount'].toString(),
        'icon': Icons.school_outlined,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                item['icon'] as IconData,
                size: 24,
                color: colorScheme.onSurfaceVariant,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['value'] as String,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item['label'] as String,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
