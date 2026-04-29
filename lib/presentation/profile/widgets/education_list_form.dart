import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'education_bottom_sheet.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../providers/profile_provider.dart';

class EducationListForm extends ConsumerWidget {
  final List<Education> education;
  final Function(List<Education>) onChanged;

  const EducationListForm({
    super.key,
    required this.education,
    required this.onChanged,
  });

  void _editEducation(
    BuildContext context,
    WidgetRef ref, {
    Education? existing,
    int? index,
  }) async {
    final result = await EducationBottomSheet.show(context, existing: existing);

    if (result != null) {
      final profileState = ref.read(profileControllerProvider);
      final currentList = profileState.currentProfile.education;
      final newList = List<Education>.from(currentList);

      if (index != null) {
        newList[index] = result;
      } else {
        final isDuplicate = newList.any(
          (edu) =>
              edu.schoolName.toLowerCase() == result.schoolName.toLowerCase() &&
              edu.degree.toLowerCase() == result.degree.toLowerCase(),
        );

        if (isDuplicate) {
          if (ref.context.mounted) {
            CustomSnackBar.showWarning(
              ref.context,
              AppLocalizations.of(ref.context)!.cvDataExists,
            );
            return;
          }
        } else {
          newList.add(result);
        }
      }

      ref.read(profileControllerProvider.notifier).updateEducation(newList);
    }
  }

  void _removeEducation(int index, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: ref.context,
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
      final profileState = ref.read(profileControllerProvider);
      final newList = List<Education>.from(
        profileState.currentProfile.education,
      );
      newList.removeAt(index);
      ref.read(profileControllerProvider.notifier).updateEducation(newList);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final education = profileState.currentProfile.education;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () => _editEducation(context, ref),
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
        if (education.isEmpty)
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
          itemCount: education.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final edu = education[index];
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
                  onPressed: () => _removeEducation(index, ref),
                ),
                onTap: () =>
                    _editEducation(context, ref, existing: edu, index: index),
              ),
            );
          },
        ),
      ],
    );
  }
}
