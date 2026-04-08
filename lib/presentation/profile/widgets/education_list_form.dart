import 'package:flutter/material.dart';
import 'education_bottom_sheet.dart';
import '../../../../domain/entities/user_profile.dart';

import '../../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class EducationListForm extends StatefulWidget {
  final List<Education> education;
  final Function(List<Education>) onChanged;
  final bool isDark;

  const EducationListForm({
    super.key,
    required this.education,
    required this.onChanged,
    this.isDark = false,
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
              style: const TextStyle(color: Colors.red),
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
    final effectiveIsDark =
        widget.isDark || Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.educationHistory,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: effectiveIsDark ? Colors.white : Colors.black,
              ),
            ),
            TextButton.icon(
              onPressed: () => _editEducation(),
              icon: Icon(
                Icons.add,
                color: effectiveIsDark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
              ),
              label: Text(
                AppLocalizations.of(context)!.add,
                style: TextStyle(
                  color: effectiveIsDark
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: effectiveIsDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey[100],
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
                color: effectiveIsDark ? Colors.white54 : Colors.grey,
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
              color: effectiveIsDark ? const Color(0xFF2C2C2C) : Colors.white,
              child: ListTile(
                title: Text(
                  edu.schoolName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: effectiveIsDark ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Text(
                  '${edu.degree}\n${edu.startDate} - ${edu.endDate ?? AppLocalizations.of(context)!.present}',
                  style: TextStyle(
                    color: effectiveIsDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
