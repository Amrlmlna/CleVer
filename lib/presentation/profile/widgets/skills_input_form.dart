import 'package:flutter/material.dart';

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
  final _controller = TextEditingController();

  void _addSkill() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.skills.contains(text)) {
      final newList = List<String>.from(widget.skills)..add(text);
      widget.onChanged(newList);
      _controller.clear();
    }
  }

  void _removeSkill(String skill) {
    final newList = List<String>.from(widget.skills)..remove(skill);
    widget.onChanged(newList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Tambah Skill',
                  hintText: 'contoh: Flutter, Leadership',
                ),
                onSubmitted: (_) => _addSkill(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _addSkill,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.skills.isEmpty)
          const Text('Belum ada skill.', style: TextStyle(color: Colors.grey))
        else
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: widget.skills.map((skill) => Chip(
              label: Text(skill),
              onDeleted: () => _removeSkill(skill),
            )).toList(),
          ),
      ],
    );
  }
}
