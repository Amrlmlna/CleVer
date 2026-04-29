import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/user_profile.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/profile_provider.dart';
import '../widgets/personal_info_form.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../widgets/experience_list_form.dart';
import '../widgets/education_list_form.dart';
import '../widgets/skills_input_form.dart';
import '../widgets/certification_list_form.dart';
import '../widgets/import_cv_button.dart';
import '../models/profile_section_data.dart';
import '../widgets/profile_stacked_sections.dart';
import '../../../core/utils/custom_snackbar.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void _handleImportSuccess(
    BuildContext context,
    WidgetRef ref,
    UserProfile importedProfile,
  ) {
    ref.read(profileControllerProvider.notifier).importProfile(importedProfile);

    CustomSnackBar.showSuccess(
      context,
      AppLocalizations.of(context)!.importSuccessMessage(
        importedProfile.experience.length,
        importedProfile.education.length,
        importedProfile.skills.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileControllerProvider);
    final currentProfile = profileState.currentProfile;

    final sections = [
      ProfileSectionData(
        title: l10n.personalInfo,
        icon: Icons.person_outline,
        bgColor: AppColors.vibrantPurple,
        textColor: Colors.white,
        iconBgColor: Colors.white,
        iconColor: Colors.black,
        child: const SizedBox.shrink(),
      ),
      ProfileSectionData(
        title: l10n.experience,
        icon: Icons.work_outline,
        bgColor: AppColors.vibrantYellow,
        textColor: Colors.black,
        iconBgColor: Colors.black,
        iconColor: Colors.white,
        child: const SizedBox.shrink(),
      ),
      ProfileSectionData(
        title: l10n.educationHistory,
        icon: Icons.school_outlined,
        bgColor: AppColors.vibrantBlack,
        textColor: Colors.white,
        iconBgColor: Colors.white,
        iconColor: Colors.black,
        child: const SizedBox.shrink(),
      ),
      ProfileSectionData(
        title: l10n.certifications,
        icon: Icons.card_membership,
        bgColor: AppColors.vibrantGreen,
        textColor: Colors.black,
        iconBgColor: Colors.white,
        iconColor: Colors.black,
        child: const SizedBox.shrink(),
      ),
      ProfileSectionData(
        title: l10n.skills,
        icon: Icons.code,
        bgColor: AppColors.vibrantBlue,
        textColor: Colors.white,
        iconBgColor: Colors.white,
        iconColor: Colors.black,
        child: const SizedBox.shrink(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ImportCVButton(
                        onImportSuccess: (importedProfile) =>
                            _handleImportSuccess(context, ref, importedProfile),
                      ),
                    ),
                    const SizedBox(height: 28),
                    ProfileStackedSections(
                      sections: sections,
                      skillsCount: currentProfile.skills.length,
                      skillsLabel: l10n.skills,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
