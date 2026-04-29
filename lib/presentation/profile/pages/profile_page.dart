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
import '../../common/widgets/unsaved_changes_dialog.dart';
import '../widgets/certification_list_form.dart';
import '../widgets/import_cv_button.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../models/profile_section_data.dart';
import '../widgets/profile_stacked_sections.dart';
import '../widgets/profile_sticky_save_bar.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<bool> _showExitWarning(BuildContext context, WidgetRef ref) async {
    final profileState = ref.read(profileControllerProvider);
    if (!profileState.hasChanges) return true;

    final result = await UnsavedChangesDialog.show(
      context,
      onSave: () async {
        await ref.read(profileControllerProvider.notifier).saveProfile();
      },
      onDiscard: () {
        ref.read(profileControllerProvider.notifier).discardChanges();
      },
    );
    return result ?? false;
  }

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

  Future<void> _saveProfile(BuildContext context, WidgetRef ref) async {
    try {
      final success = await ref
          .read(profileControllerProvider.notifier)
          .saveProfile();
      if (success && context.mounted) {
        CustomSnackBar.showSuccess(
          context,
          AppLocalizations.of(context)!.profileSavedSuccess,
        );
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          AppLocalizations.of(context)!.profileSaveError(e.toString()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileControllerProvider);
    final currentProfile = profileState.currentProfile;
    final hasChanges = profileState.hasChanges;
    final isSaving = profileState.isSaving;

    final sections = [
      ProfileSectionData(
        title: l10n.personalInfo,
        icon: Icons.person_outline,
        bgColor: AppColors.vibrantPurple,
        textColor: Colors.white,
        iconBgColor: Colors.white,
        iconColor: Colors.black,
        child: const PersonalInfoForm(),
      ),
      ProfileSectionData(
        title: l10n.experience,
        icon: Icons.work_outline,
        bgColor: AppColors.vibrantYellow,
        textColor: Colors.black,
        iconBgColor: Colors.black,
        iconColor: Colors.white,
        child: ExperienceListForm(
          experiences: currentProfile.experience,
          onChanged: (val) => ref
              .read(profileControllerProvider.notifier)
              .updateExperience(val),
        ),
      ),
      ProfileSectionData(
        title: l10n.educationHistory,
        icon: Icons.school_outlined,
        bgColor: AppColors.vibrantBlack,
        textColor: Colors.white,
        iconBgColor: Colors.white,
        iconColor: Colors.black,
        child: EducationListForm(
          education: currentProfile.education,
          onChanged: (val) =>
              ref.read(profileControllerProvider.notifier).updateEducation(val),
        ),
      ),
      ProfileSectionData(
        title: l10n.certifications,
        icon: Icons.card_membership,
        bgColor: AppColors.vibrantGreen,
        textColor: Colors.black,
        iconBgColor: Colors.white,
        iconColor: Colors.black,
        child: CertificationListForm(
          certifications: currentProfile.certifications,
          onChanged: (val) => ref
              .read(profileControllerProvider.notifier)
              .updateCertifications(val),
        ),
      ),
      ProfileSectionData(
        title: l10n.skills,
        icon: Icons.code,
        bgColor: AppColors.vibrantBlue,
        textColor: Colors.white,
        iconBgColor: Colors.white,
        iconColor: Colors.black,
        child: SkillsInputForm(
          skills: currentProfile.skills,
          onChanged: (val) =>
              ref.read(profileControllerProvider.notifier).updateSkills(val),
        ),
      ),
    ];

    return Scaffold(
      body: PopScope(
        canPop: !hasChanges || isSaving,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await _showExitWarning(context, ref);
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
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
                              _handleImportSuccess(
                                context,
                                ref,
                                importedProfile,
                              ),
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

              if (hasChanges)
                ProfileStickySaveBar(
                  hasChanges: hasChanges,
                  isSaving: isSaving,
                  onSave: () => _saveProfile(context, ref),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
