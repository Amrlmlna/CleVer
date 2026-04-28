import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';
import 'experience_bottom_sheet.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../core/utils/custom_snackbar.dart';

class ExperienceListForm extends StatefulWidget {
  final List<Experience> experiences;
  final Function(List<Experience>) onChanged;

  const ExperienceListForm({
    super.key,
    required this.experiences,
    required this.onChanged,
  });

  @override
  State<ExperienceListForm> createState() => _ExperienceListFormState();
}

class _ExperienceListFormState extends State<ExperienceListForm> {
  void _editExperience({Experience? existing, int? index}) async {
    final result = await ExperienceBottomSheet.show(
      context,
      existing: existing,
    );

    if (result != null) {
      final newList = List<Experience>.from(widget.experiences);

      if (index != null) {
        newList[index] = result;
        widget.onChanged(newList);
      } else {
        final isDuplicate = newList.any(
          (exp) =>
              exp.jobTitle.toLowerCase() == result.jobTitle.toLowerCase() &&
              exp.companyName.toLowerCase() ==
                  result.companyName.toLowerCase() &&
              exp.startDate == result.startDate,
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

  void _removeExperience(int index) async {
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
      final newList = List<Experience>.from(widget.experiences);
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
              onPressed: () => _editExperience(),
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
        if (widget.experiences.isEmpty)
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
          itemCount: widget.experiences.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final exp = widget.experiences[index];
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
                  onPressed: () => _removeExperience(index),
                ),
                onTap: () => _editExperience(existing: exp, index: index),
              ),
            );
          },
        ),
      ],
    );
  }
}
