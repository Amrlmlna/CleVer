import 'package:flutter/material.dart';
import '../../../domain/entities/user_profile.dart';
import '../../profile/widgets/experience_list_form.dart';

class OnboardingExperienceStep extends StatelessWidget {
  final List<Experience> experiences;
  final ValueChanged<List<Experience>> onChanged;

  const OnboardingExperienceStep({
    super.key,
    required this.experiences,
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
            'Pengalaman Kerja',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ceritain pengalaman kerjamu di sini.',
             style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ExperienceListForm(
            experiences: experiences,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
