import 'package:flutter/material.dart';
import 'education_bottom_sheet.dart';
import '../../../../domain/entities/user_profile.dart';

import '../../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class EducationListForm extends StatefulWidget {
  final List<Education> education;
  final Function(List<Education>) onChanged;

  const EducationListForm({
    super.key,
    required this.education,
    required this.onChanged,
  });

  @override
  State<EducationListForm> createState() => _EducationListFormState();
}

class _EducationListFormState extends State<EducationListForm> {
  void _editEducation({Education? existing, int? index}) async {
    final result = await EducationBottomSheet.show(context, existing: existing);

    if (result != null) {
      final newList = List<Education>.from(widget.education);

      if (index != null) {
        newList[index] = result;
        widget.onChanged(newList);
      } else {
        final isDuplicate = newList.any(
          (edu) =>
              edu.schoolName.toLowerCase() == result.schoolName.toLowerCase() &&
              edu.degree.toLowerCase() == result.degree.toLowerCase(),
        );

        if (isDuplicate) {
          if (mounted) {
            CustomSnackBar.showWarning(
              context,
              AppLocalizations.of(context)!.cvDataExists,
            );
          }
        } else {
          newList.add(result);
          widget.onChanged(newList);
        }
      }
    }
  }

  void _removeEducation(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDelete),
        content: Text(AppLocalizations.of(context)!.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final newList = List<Education>.from(widget.education);
      newList.removeAt(index);
      widget.onChanged(newList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () => _editEducation(),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                AppLocalizations.of(context)!.add,
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
        if (widget.education.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              AppLocalizations.of(context)!.noEducation,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.education.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final edu = widget.education[index];
            return Card(
              margin: EdgeInsets.zero,
              color: Theme.of(context).cardTheme.color,
              child: ListTile(
                title: Text(
                  edu.schoolName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${edu.degree} | ${edu.startDate} - ${edu.endDate ?? AppLocalizations.of(context)!.present}${edu.gpa != null ? " | GPA: ${edu.gpa}" : ""}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    if (edu.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        edu.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    if (edu.subjects.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: edu.subjects.take(5).map((subject) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              subject.name,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (edu.subjects.length > 5)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 2),
                          child: Text(
                            '+${edu.subjects.length - 5} more subjects',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => _removeEducation(index),
                ),
                onTap: () => _editEducation(existing: edu, index: index),
              ),
            );
          },
        ),
      ],
    );
  }
}
