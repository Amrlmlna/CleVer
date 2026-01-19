import 'package:flutter/material.dart';
import '../../../domain/entities/user_profile.dart';
import '../../profile/widgets/education_list_form.dart';

class OnboardingEducationStep extends StatelessWidget {
  final List<Education> education;
  final ValueChanged<List<Education>> onChanged;

  const OnboardingEducationStep({
    super.key,
    required this.education,
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
            'Where did you learn?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your academic background.',
             style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          EducationListForm(
            education: education,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
