import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/personal_info_form.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../widgets/experience_list_form.dart';
import '../widgets/education_list_form.dart';
import '../widgets/skills_input_form.dart';
import '../widgets/certification_list_form.dart';
import '../widgets/section_card.dart';
import '../widgets/import_cv_button.dart';
import '../widgets/profile_action_buttons.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../widgets/delete_account_dialog.dart';
import '../widgets/danger_zone.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    
    _nameController.addListener(_onNameChanged);
    _emailController.addListener(_onEmailChanged);
    _phoneController.addListener(_onPhoneChanged);
    _locationController.addListener(_onLocationChanged);
  }

  void _onNameChanged() {
    ref.read(profileControllerProvider.notifier).updateName(_nameController.text);
  }

  void _onEmailChanged() {
    ref.read(profileControllerProvider.notifier).updateEmail(_emailController.text);
  }

  void _onPhoneChanged() {
    ref.read(profileControllerProvider.notifier).updatePhone(_phoneController.text);
  }

  void _onLocationChanged() {
    ref.read(profileControllerProvider.notifier).updateLocation(_locationController.text);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  
  void _syncControllers(UserProfile profile) {
    if (_nameController.text != profile.fullName) {
      _nameController.text = profile.fullName;
    }
    if (_emailController.text != profile.email) {
      _emailController.text = profile.email;
    }
    if (_phoneController.text != (profile.phoneNumber ?? '')) {
      _phoneController.text = profile.phoneNumber ?? '';
    }
    if (_locationController.text != (profile.location ?? '')) {
      _locationController.text = profile.location ?? '';
    }
  }

  Future<bool> _showExitWarning() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.saveChangesTitle),
        content: Text(AppLocalizations.of(context)!.saveChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Leave anyway
            child: Text(AppLocalizations.of(context)!.exitWithoutSaving, style: const TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false), // Stay
            child: Text(AppLocalizations.of(context)!.stayHere),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _handleImportSuccess(UserProfile importedProfile) {
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

  Future<void> _saveProfile() async {
    try {
      final success = await ref.read(profileControllerProvider.notifier).saveProfile();
      if (success && mounted) {
        CustomSnackBar.showSuccess(context, AppLocalizations.of(context)!.profileSavedSuccess);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, AppLocalizations.of(context)!.profileSaveError(e.toString()));
      }
    }
  }



  Future<void> _confirmAccountDeletion() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteAccountDialog(),
    );

    if (result == true) {
      _performDeletion();
    }
  }

  Future<void> _performDeletion() async {
    try {
      await ref.read(profileControllerProvider.notifier).deleteAccount();
      
      if (mounted) {
        CustomSnackBar.showSuccess(context, 'Account successfully deleted. Goodbye!');
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, 'Failed to delete account: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final currentProfile = profileState.currentProfile;
    final hasChanges = profileState.hasChanges;
    final isSaving = profileState.isSaving;

    ref.listen(profileControllerProvider, (prev, next) {
      if (prev?.currentProfile != next.currentProfile) {
         _syncControllers(next.currentProfile);
      }
    });

    return Scaffold(
      body: PopScope(
        canPop: !hasChanges || isSaving,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await _showExitWarning();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const SizedBox(height: 16),

                ImportCVButton(
                  onImportSuccess: _handleImportSuccess,
                ),

                const SizedBox(height: 32),

                SectionCard(
                  title: AppLocalizations.of(context)!.personalInfo,
                  icon: Icons.person_outline,
                  child: PersonalInfoForm(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    locationController: _locationController,
                  ),
                ),
                
                const SizedBox(height: 24),

                SectionCard(
                  title: AppLocalizations.of(context)!.experience,
                  icon: Icons.work_outline,
                  child: ExperienceListForm(
                    experiences: currentProfile.experience,
                    onChanged: (val) => ref.read(profileControllerProvider.notifier).updateExperience(val),
                  ),
                ),

                const SizedBox(height: 24),

                SectionCard(
                  title: AppLocalizations.of(context)!.educationHistory,
                  icon: Icons.school_outlined,
                  child: EducationListForm(
                    education: currentProfile.education,
                    onChanged: (val) => ref.read(profileControllerProvider.notifier).updateEducation(val),
                  ),
                ),

                const SizedBox(height: 24),

                SectionCard(
                  title: AppLocalizations.of(context)!.certifications,
                  icon: Icons.card_membership,
                  child: CertificationListForm(
                    certifications: currentProfile.certifications,
                    onChanged: (val) => ref.read(profileControllerProvider.notifier).updateCertifications(val),
                  ),
                ),

                const SizedBox(height: 24),

                SectionCard(
                  title: AppLocalizations.of(context)!.skills,
                  icon: Icons.code,
                  child: SkillsInputForm(
                    skills: currentProfile.skills,
                    onChanged: (val) => ref.read(profileControllerProvider.notifier).updateSkills(val),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Legal Information'),
                  subtitle: const Text('Privacy Policy and Terms'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/legal'),
                ),

                const SizedBox(height: 24),

                const Divider(),
                const SizedBox(height: 24),
                
                DangerZone(
                  isSaving: isSaving,
                  onConfirmDeletion: _confirmAccountDeletion,
                ),

                const SizedBox(height: 32),

                ProfileActionButtons(
                  onSave: _saveProfile,
                  canSave: hasChanges && !isSaving,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
