import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';

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
      builder: (context) => _ExperienceDialog(existing: existing),
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

class _ExperienceDialog extends StatefulWidget {
  final Experience? existing;

  const _ExperienceDialog({this.existing});

  @override
  State<_ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends State<_ExperienceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.jobTitle);
    _companyCtrl = TextEditingController(text: widget.existing?.companyName);
    _startCtrl = TextEditingController(text: widget.existing?.startDate);
    _endCtrl = TextEditingController(text: widget.existing?.endDate);
    _descCtrl = TextEditingController(text: widget.existing?.description);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Experience' : 'Edit Experience'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _companyCtrl,
                decoration: const InputDecoration(labelText: 'Company'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startCtrl,
                      decoration: const InputDecoration(labelText: 'Start (MM/YYYY)'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _endCtrl,
                      decoration: const InputDecoration(labelText: 'End (Optional)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final exp = Experience(
                jobTitle: _titleCtrl.text,
                companyName: _companyCtrl.text,
                startDate: _startCtrl.text,
                endDate: _endCtrl.text.isEmpty ? null : _endCtrl.text,
                description: _descCtrl.text,
              );
              Navigator.pop(context, exp);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
