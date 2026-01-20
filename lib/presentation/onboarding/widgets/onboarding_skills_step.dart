import 'package:flutter/material.dart';
import '../../profile/widgets/skills_input_form.dart';

class OnboardingSkillsStep extends StatelessWidget {
  final List<String> skills;
  final ValueChanged<List<String>> onChanged;

  const OnboardingSkillsStep({
    super.key,
    required this.skills,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skill Kamu Apa Aja?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tulis skill teknis atau soft skill kamu.',
             style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          SkillsInputForm(
            skills: skills,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
