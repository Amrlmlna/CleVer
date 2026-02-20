import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';
import '../providers/profile_unsaved_changes_provider.dart';
import '../widgets/personal_info_form.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../widgets/experience_list_form.dart';
import '../widgets/education_list_form.dart';
import '../widgets/skills_input_form.dart';
import '../widgets/certification_list_form.dart';
import '../widgets/section_card.dart';
import '../widgets/import_cv_button.dart';
import '../widgets/profile_action_buttons.dart';
import '../widgets/danger_zone.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../providers/profile_form_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  
  List<Experience> _experience = [];
  List<Education> _education = [];
  List<String> _skills = [];
  List<Certification> _certifications = [];
  
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _locationController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _loadFromProvider();
      _isInit = false;
    }
  }

  void _loadFromProvider() {
    final masterProfile = ref.read(masterProfileProvider);
    
    if (masterProfile != null) {
      _nameController.text = masterProfile.fullName;
      _emailController.text = masterProfile.email;
      _phoneController.text = masterProfile.phoneNumber ?? '';
      _locationController.text = masterProfile.location ?? '';
      
      setState(() {
        _experience = List.from(masterProfile.experience);
        _education = List.from(masterProfile.education);
        _skills = List.from(masterProfile.skills);
        _certifications = List.from(masterProfile.certifications);
      });
    } else {
       _nameController.clear();
       _emailController.clear();
       _phoneController.clear();
       _locationController.clear();
       setState(() {
          _experience = [];
         _education = [];
         _skills = [];
         _certifications = [];
       });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }



  bool _hasChanges() {
    final masterProfile = ref.read(masterProfileProvider);
    bool changed = false;

    if (masterProfile == null) {
      changed = _nameController.text.isNotEmpty ||
          _emailController.text.isNotEmpty ||
          _phoneController.text.isNotEmpty ||
          _locationController.text.isNotEmpty ||
          _experience.isNotEmpty ||
          _education.isNotEmpty ||
          _skills.isNotEmpty ||
          _certifications.isNotEmpty;
    } else {
      final currentLocal = UserProfile(
        fullName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        location: _locationController.text,
        experience: _experience,
        education: _education,
        skills: _skills,
        certifications: _certifications,
      );
      changed = currentLocal != masterProfile;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(profileUnsavedChangesProvider.notifier).state = changed;
      }
    });

    return changed;
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
    if (_nameController.text.isEmpty) {
      _nameController.text = importedProfile.fullName;
    }
    if (_emailController.text.isEmpty) {
      _emailController.text = importedProfile.email;
    }
    if (_phoneController.text.isEmpty && importedProfile.phoneNumber != null) {
      _phoneController.text = importedProfile.phoneNumber!;
    }
    if (_locationController.text.isEmpty && importedProfile.location != null) {
      _locationController.text = importedProfile.location!;
    }
    
    setState(() {
      _experience = [..._experience, ...importedProfile.experience];
      _education = [..._education, ...importedProfile.education];
      
      final allSkills = {..._skills, ...importedProfile.skills}.toList();
      _skills = allSkills;
      
      _certifications = [..._certifications, ...importedProfile.certifications];
    });

    CustomSnackBar.showSuccess(
      context,
      AppLocalizations.of(context)!.importSuccessMessage(
        importedProfile.experience.length,
        importedProfile.education.length,
        importedProfile.skills.length,
      ),
    );
  }

  void _saveProfile() {
    if (_nameController.text.isEmpty) {
      CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.fillNameError);
      return;
    }

    final newProfile = UserProfile(
      fullName: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
      experience: _experience,
      education: _education,
      skills: _skills,
      certifications: _certifications,
    );

    ref.read(profileFormStateProvider.notifier).setSaving(true);

    try {
      ref.read(masterProfileProvider.notifier).saveProfile(newProfile);
      
      if (mounted) {
        CustomSnackBar.showSuccess(context, AppLocalizations.of(context)!.profileSavedSuccess);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, AppLocalizations.of(context)!.profileSaveError(e.toString()));
      }
    } finally {
      if (mounted) {
        ref.read(profileFormStateProvider.notifier).setSaving(false);
      }
    }
  }

  Future<void> _confirmAccountDeletion() async {
    final confirmationController = TextEditingController();
    bool canDelete = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Delete Account?', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('This is irreversible. You will lose:'),
              const SizedBox(height: 8),
              const Text('• All your generated CVs'),
              const Text('• Your profile information'),
              const Text('• All remaining credits'),
              const SizedBox(height: 16),
              const Text('Type "DELETE" to confirm:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: confirmationController,
                decoration: const InputDecoration(
                  hintText: 'DELETE',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (val) {
                  setDialogState(() => canDelete = val.toUpperCase() == 'DELETE');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: canDelete ? () => Navigator.pop(context, true) : null,
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete My Data'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      _performDeletion();
    }
  }

  Future<void> _performDeletion() async {
    ref.read(profileFormStateProvider.notifier).setSaving(true);
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      await ref.read(masterProfileProvider.notifier).clearProfile();
      
      if (mounted) {
        CustomSnackBar.showSuccess(context, 'Account successfully deleted. Goodbye!');
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, 'Failed to delete account: $e');
      }
    } finally {
      if (mounted) {
        ref.read(profileFormStateProvider.notifier).setSaving(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(profileFormStateProvider).isSaving;

    ref.listen(masterProfileProvider, (prev, next) {
      if (prev != next) {
        _loadFromProvider();
      }
    });

    return Scaffold(
      body: PopScope(
        canPop: !_hasChanges() || isSaving,
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
                experiences: _experience,
                onChanged: (val) => setState(() => _experience = val),
              ),
            ),

            const SizedBox(height: 24),

            SectionCard(
              title: AppLocalizations.of(context)!.educationHistory,
              icon: Icons.school_outlined,
              child: EducationListForm(
                education: _education,
                onChanged: (val) => setState(() => _education = val),
              ),
            ),

            const SizedBox(height: 24),

            SectionCard(
              title: AppLocalizations.of(context)!.certifications,
              icon: Icons.card_membership,
              child: CertificationListForm(
                certifications: _certifications,
                onChanged: (val) => setState(() => _certifications = val),
              ),
            ),

            const SizedBox(height: 24),

            SectionCard(
              title: AppLocalizations.of(context)!.skills,
              icon: Icons.code,
              child: SkillsInputForm(
                skills: _skills,
                onChanged: (val) => setState(() => _skills = val),
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
            
            // Danger Zone (Extracted)
            DangerZone(
              isSaving: ref.watch(profileFormStateProvider).isSaving,
              onConfirmDeletion: _confirmAccountDeletion,
            ),

            const SizedBox(height: 32),

            // Action Buttons (Extracted Widget)
            ProfileActionButtons(
              onSave: _saveProfile,
              canSave: _hasChanges() && !ref.watch(profileFormStateProvider).isSaving,
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }
}
