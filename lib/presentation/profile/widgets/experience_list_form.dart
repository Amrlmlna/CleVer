import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user_profile.dart';
import 'experience_bottom_sheet.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../providers/profile_provider.dart';

class ExperienceListForm extends ConsumerWidget {
  final List<Experience> experiences;
  final Function(List<Experience>) onChanged;

  const ExperienceListForm({
    super.key,
    required this.experiences,
    required this.onChanged,
  });

  void _editExperience(
    BuildContext context,
    WidgetRef ref, {
    Experience? existing,
    int? index,
  }) async {
    final result = await ExperienceBottomSheet.show(
      context,
      existing: existing,
    );

    if (result != null) {
      final profileState = ref.read(profileControllerProvider);
      final currentList = profileState.currentProfile.experience;
      final newList = List<Experience>.from(currentList);

      if (index != null) {
        newList[index] = result;
      } else {
        final isDuplicate = newList.any(
          (exp) =>
              exp.jobTitle.toLowerCase() == result.jobTitle.toLowerCase() &&
              exp.companyName.toLowerCase() ==
                  result.companyName.toLowerCase() &&
              exp.startDate == result.startDate,
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

      ref.read(profileControllerProvider.notifier).updateExperience(newList);
    }
  }

  void _removeExperience(int index, WidgetRef ref) async {
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
      final newList = List<Experience>.from(
        profileState.currentProfile.experience,
      );
      newList.removeAt(index);
      ref.read(profileControllerProvider.notifier).updateExperience(newList);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final experiences = profileState.currentProfile.experience;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () => _editExperience(context, ref),
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
        if (experiences.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              AppLocalizations.of(context)!.noExperience,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: experiences.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final exp = experiences[index];
            return Card(
              margin: EdgeInsets.zero,
              color: Theme.of(context).cardTheme.color,
              child: ListTile(
                title: Text(
                  exp.jobTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  '${exp.companyName}\n${exp.startDate} - ${exp.endDate ?? AppLocalizations.of(context)!.present}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => _removeExperience(index, ref),
                ),
                onTap: () =>
                    _editExperience(context, ref, existing: exp, index: index),
              ),
            );
          },
        ),
      ],
    );
  }
}
