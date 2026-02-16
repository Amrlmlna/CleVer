import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';
import 'experience_dialog.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class ExperienceListForm extends StatefulWidget {
  final List<Experience> experiences;
  final Function(List<Experience>) onChanged;
  final bool isDark;

  const ExperienceListForm({
    super.key,
    required this.experiences,
    required this.onChanged,
    this.isDark = false,
  });

  @override
  State<ExperienceListForm> createState() => _ExperienceListFormState();
}

class _ExperienceListFormState extends State<ExperienceListForm> {
  void _editExperience({Experience? existing, int? index}) async {
    final result = await showDialog<Experience>(
      context: context,
      builder: (context) => ExperienceDialog(existing: existing),
    );

    if (result != null) {
      final newList = List<Experience>.from(widget.experiences);
      if (index != null) {
        newList[index] = result;
      } else {
        newList.add(result);
      }
      widget.onChanged(newList);
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
              style: const TextStyle(color: Colors.red),
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
    // Check both explicit flag and system theme
    final effectiveIsDark = widget.isDark || Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.workExperience, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: effectiveIsDark ? Colors.white : Colors.black)),
            TextButton.icon(
              onPressed: () => _editExperience(),
              icon: Icon(Icons.add, color: effectiveIsDark ? Colors.white : Theme.of(context).primaryColor),
              label: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: effectiveIsDark ? Colors.white : Theme.of(context).primaryColor)),
              style: TextButton.styleFrom(
                backgroundColor: effectiveIsDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
        if (widget.experiences.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(AppLocalizations.of(context)!.noExperience, style: TextStyle(color: effectiveIsDark ? Colors.white54 : Colors.grey)),
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
              color: effectiveIsDark ? const Color(0xFF2C2C2C) : Colors.white, // Explicit card color for contrast
              child: ListTile(
                title: Text(exp.jobTitle, style: TextStyle(fontWeight: FontWeight.bold, color: effectiveIsDark ? Colors.white : Colors.black)),
                subtitle: Text('${exp.companyName}\n${exp.startDate} - ${exp.endDate ?? AppLocalizations.of(context)!.present}', style: TextStyle(color: effectiveIsDark ? Colors.white70 : Colors.black87)),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
