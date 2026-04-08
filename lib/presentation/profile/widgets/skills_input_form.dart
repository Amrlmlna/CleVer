import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'skills_bottom_sheet.dart';

class SkillsInputForm extends StatefulWidget {
  final List<String> skills;
  final Function(List<String>) onChanged;

  const SkillsInputForm({
    super.key,
    required this.skills,
    required this.onChanged,
  });

  @override
  State<SkillsInputForm> createState() => _SkillsInputFormState();
}

class _SkillsInputFormState extends State<SkillsInputForm> {
  void _showAddSkill() async {
    final result = await SkillsBottomSheet.show(context, widget.skills);
    if (result != null && result.isNotEmpty) {
      final newList = List<String>.from(widget.skills)..add(result);
      widget.onChanged(newList);
    }
  }

  void _removeSkill(String skill) {
    final newList = List<String>.from(widget.skills)..remove(skill);
    widget.onChanged(newList);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.skills,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: _showAddSkill,
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                l10n.add,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.skills.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              l10n.noSkills,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          )
        else
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: widget.skills
                .map(
                  (skill) => Chip(
                    label: Text(
                      skill,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onDeleted: () => _removeSkill(skill),
                    deleteIcon: Icon(
                      Icons.cancel,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
