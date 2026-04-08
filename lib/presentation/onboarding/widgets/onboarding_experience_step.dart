import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
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
          Text(
            AppLocalizations.of(context)!.experienceTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.experienceSubtitle,
            style: const TextStyle(color: Colors.grey, height: 1.5),
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
