import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';
import 'experience_dialog.dart';

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

  void _removeExperience(int index) {
    final newList = List<Experience>.from(widget.experiences);
    newList.removeAt(index);
    widget.onChanged(newList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Experience', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton.icon(
              onPressed: () => _editExperience(),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        if (widget.experiences.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('No experience added yet.', style: TextStyle(color: Colors.grey)),
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
              child: ListTile(
                title: Text(exp.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${exp.companyName}\n${exp.startDate} - ${exp.endDate ?? "Present"}'),
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
