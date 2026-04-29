import 'package:flutter/material.dart';
import '../../../../domain/entities/subject.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import './study_card_scanner.dart';

class SubjectListSection extends StatefulWidget {
  final List<Subject> subjects;
  final Function(List<Subject>) onChanged;
  final Function({String? gpa, required List<Subject> subjects}) onScanResult;

  const SubjectListSection({
    super.key,
    required this.subjects,
    required this.onChanged,
    required this.onScanResult,
  });

  @override
  State<SubjectListSection> createState() => _SubjectListSectionState();
}

class _SubjectListSectionState extends State<SubjectListSection> {
  void _addSubject() {
    _showSubjectDialog();
  }

  void _editSubject(Subject subject) {
    _showSubjectDialog(existing: subject);
  }

  void _showSubjectDialog({Subject? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name);
    final gradeCtrl = TextEditingController(text: existing?.grade);
    final descCtrl = TextEditingController(text: existing?.description);
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          existing == null ? localization.addSubject : localization.editSubject,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: localization.subjectName),
              autofocus: true,
            ),
            TextField(
              controller: gradeCtrl,
              decoration: InputDecoration(
                labelText: localization.gradeOptional,
              ),
            ),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(
                labelText: localization.whatDidYouLearn,
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localization.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                final newSubject = Subject(
                  name: nameCtrl.text,
                  grade: gradeCtrl.text.isEmpty ? null : gradeCtrl.text,
                  description: descCtrl.text.isEmpty ? null : descCtrl.text,
                );

                final newList = List<Subject>.from(widget.subjects);
                if (existing != null) {
                  final index = newList.indexOf(existing);
                  if (index != -1) newList[index] = newSubject;
                } else {
                  newList.add(newSubject);
                }

                widget.onChanged(newList);
                Navigator.pop(context);
              }
            },
            child: Text(
              existing == null ? localization.add : localization.update,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localization.academicSubjects,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            StudyCardScanner(onResult: widget.onScanResult),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.subjects.isEmpty)
          Center(
            child: Text(
              localization.noSubjectsAdded,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.sheetOnSurfaceVar,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.subjects.map((subject) {
              return GestureDetector(
                onTap: () => _editSubject(subject),
                child: Chip(
                  label: Text(
                    '${subject.name}${subject.grade != null ? " (${subject.grade})" : ""}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () {
                    final newList = List<Subject>.from(widget.subjects);
                    newList.remove(subject);
                    widget.onChanged(newList);
                  },
                  backgroundColor: AppColors.sheetInputFill,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addSubject,
          icon: const Icon(Icons.add, size: 18),
          label: Text(localization.addSubjectManually),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
