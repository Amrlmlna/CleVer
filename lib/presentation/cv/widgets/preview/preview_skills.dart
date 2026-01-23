import 'package:flutter/material.dart';
import 'section_header.dart';

class PreviewSkills extends StatelessWidget {
  final List<String> skills;
  final Function(String) onAddSkill;
  final String language;

  const PreviewSkills({
    super.key,
    required this.skills,
    required this.onAddSkill,
    this.language = 'id',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: language == 'en' ? 'SKILLS' : 'SKILL'),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: [
            ...skills.map((skill) => Chip(
              label: Text(
                skill, 
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              backgroundColor: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200],
              side: isDark ? BorderSide(color: Colors.white.withOpacity(0.1)) : BorderSide.none,
            )),
            ActionChip(
              label: Icon(Icons.add, size: 16, color: isDark ? Colors.white : Colors.black),
              padding: EdgeInsets.zero,
              backgroundColor: isDark ? Colors.transparent : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isDark ? Colors.white.withOpacity(0.3) : Colors.grey.shade400, 
                  style: BorderStyle.solid
                ),
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
