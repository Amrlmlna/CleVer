import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
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
          Text(
            AppLocalizations.of(context)!.educationTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.educationSubtitle,
            style: const TextStyle(color: Colors.grey, height: 1.5),
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
