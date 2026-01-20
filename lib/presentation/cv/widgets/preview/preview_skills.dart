import 'package:flutter/material.dart';
import 'section_header.dart';

class PreviewSkills extends StatelessWidget {
  final List<String> skills;
  final Function(String) onAddSkill;

  const PreviewSkills({
    super.key,
    required this.skills,
    required this.onAddSkill,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'SKILL'),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: [
            ...skills.map((skill) => Chip(
              label: Text(skill),
              backgroundColor: Colors.grey[200],
            )),
            ActionChip(
              label: const Icon(Icons.add, size: 16),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade400, style: BorderStyle.solid),
              ),
              onPressed: () async {
                final newSkill = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    String skill = '';
                    return AlertDialog(
                      title: const Text('Tambah Skill'),
                      content: TextField(
                        autofocus: true,
                        decoration: const InputDecoration(hintText: 'Nama skill'),
                        onChanged: (val) => skill = val,
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, skill),
                          child: const Text('Tambah'),
                        ),
                      ],
                    );
                  }
                );
                
                if (newSkill != null && newSkill.isNotEmpty) {
                  onAddSkill(newSkill);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
