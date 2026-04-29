import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../domain/entities/skill.dart';
import 'skills_bottom_sheet.dart';
import '../providers/profile_provider.dart';

class SkillsInputForm extends ConsumerWidget {
  final List<Skill> skills;
  final Function(List<Skill>) onChanged;

  const SkillsInputForm({
    super.key,
    required this.skills,
    required this.onChanged,
  });

  void _showAddSkill(BuildContext context, WidgetRef ref) async {
    final profileState = ref.read(profileControllerProvider);
    final result = await SkillsBottomSheet.show(
      context,
      profileState.currentProfile.skills,
    );
    if (result != null) {
      final newList = List<Skill>.from(profileState.currentProfile.skills)
        ..add(result);
      ref.read(profileControllerProvider.notifier).updateSkills(newList);
    }
  }

  void _removeSkill(Skill skill, WidgetRef ref) {
    final profileState = ref.read(profileControllerProvider);
    final newList = List<Skill>.from(profileState.currentProfile.skills)
      ..remove(skill);
    ref.read(profileControllerProvider.notifier).updateSkills(newList);
  }

  Map<SkillCategory, List<Skill>> _getGroupedSkills(List<Skill> skills) {
    final grouped = <SkillCategory, List<Skill>>{};
    for (final skill in skills) {
      grouped.putIfAbsent(skill.category, () => []).add(skill);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final skills = profileState.currentProfile.skills;
    final l10n = AppLocalizations.of(context)!;
    final isId = Localizations.localeOf(context).languageCode == 'id';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () => _showAddSkill(context, ref),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                l10n.add,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (skills.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              l10n.noSkills,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          ..._getGroupedSkills(skills).entries.map((entry) {
            final category = entry.key;
            final skillsList = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isId ? category.displayNameId : category.displayName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: skillsList
                        .map(
                          (skill) => Chip(
                            label: Text(
                              skill.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onDeleted: () => _removeSkill(skill, ref),
                            deleteIcon: Icon(
                              Icons.cancel,
                              size: 18,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
