import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/unsaved_changes_dialog.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../widgets/profile_stacked_sections.dart';
import '../widgets/personal_info_form.dart';
import '../widgets/experience_list_form.dart';
import '../widgets/education_list_form.dart';
import '../widgets/certification_list_form.dart';
import '../widgets/skills_input_form.dart';
import '../widgets/experience_bottom_sheet.dart';
import '../widgets/education_bottom_sheet.dart';
import '../widgets/certification_bottom_sheet.dart';
import '../widgets/skills_bottom_sheet.dart';
import '../../../../domain/entities/user_profile.dart';

class SectionEditPage extends ConsumerStatefulWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final Color iconBgColor;
  final Color iconColor;
  final SectionType sectionType;
  final bool autoOpenAddSheet;

  const SectionEditPage({
    super.key,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.sectionType,
    this.autoOpenAddSheet = false,
  });

  @override
  ConsumerState<SectionEditPage> createState() => _SectionEditPageState();
}

class _SectionEditPageState extends ConsumerState<SectionEditPage> {
  bool _canPopNow = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider).currentProfile;
    _nameController = TextEditingController(text: profile.fullName);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phoneNumber ?? '');
    _locationController = TextEditingController(text: profile.location ?? '');
    _birthDateController = TextEditingController(text: profile.birthDate ?? '');
    _genderController = TextEditingController(text: profile.gender ?? '');

    _nameController.addListener(_onNameChanged);
    _emailController.addListener(_onEmailChanged);
    _phoneController.addListener(_onPhoneChanged);
    _locationController.addListener(_onLocationChanged);
    _birthDateController.addListener(_onBirthDateChanged);
    _genderController.addListener(_onGenderChanged);

    if (widget.autoOpenAddSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerAddSheet();
      });
    }
  }

  void _onNameChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updateName(_nameController.text);
  }

  void _onEmailChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updateEmail(_emailController.text);
  }

  void _onPhoneChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updatePhone(_phoneController.text);
  }

  void _onLocationChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updateLocation(_locationController.text);
  }

  void _onBirthDateChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updateBirthDate(_birthDateController.text);
  }

  void _onGenderChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updateGender(_genderController.text);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _triggerAddSheet() async {
    final profileState = ref.read(profileControllerProvider);
    final notifier = ref.read(profileControllerProvider.notifier);

    switch (widget.sectionType) {
      case SectionType.experience:
        final result = await ExperienceBottomSheet.show(context);
        if (result != null && mounted) {
          final newList = List<Experience>.from(
            profileState.currentProfile.experience,
          )..add(result);
          notifier.updateExperience(newList);
        }
        break;
      case SectionType.education:
        final result = await EducationBottomSheet.show(context);
        if (result != null && mounted) {
          final newList = List<Education>.from(
            profileState.currentProfile.education,
          )..add(result);
          notifier.updateEducation(newList);
        }
        break;
      case SectionType.certifications:
        final result = await CertificationBottomSheet.show(context);
        if (result != null && mounted) {
          final newList = List<Certification>.from(
            profileState.currentProfile.certifications,
          )..add(result);
          notifier.updateCertifications(newList);
        }
        break;
      case SectionType.skills:
        final result = await SkillsBottomSheet.show(
          context,
          profileState.currentProfile.skills,
        );
        if (result != null && mounted) {
          final newList = List<Skill>.from(profileState.currentProfile.skills)
            ..add(result);
          notifier.updateSkills(newList);
        }
        break;
      case SectionType.personalInfo:
        // No add sheet for personal info
        break;
    }
  }

  void _handleSave() async {
    final success = await ref
        .read(profileControllerProvider.notifier)
        .saveProfile();
    if (success && mounted) {
      CustomSnackBar.showSuccess(
        context,
        AppLocalizations.of(context)!.profileSavedSuccess,
      );
    }
  }

  void _handlePop() async {
    if (_canPopNow) return;

    final profileState = ref.read(profileControllerProvider);
    if (!profileState.hasChanges) {
      setState(() => _canPopNow = true);
      Navigator.pop(context);
      return;
    }

    final result = await UnsavedChangesDialog.show(
      context,
      onSave: () async {
        await ref.read(profileControllerProvider.notifier).saveProfile();
      },
      onDiscard: () async {
        ref.read(profileControllerProvider.notifier).discardChanges();
      },
    );

    if (result == true && mounted) {
      setState(() => _canPopNow = true);
      Navigator.pop(context);
    }
  }

  Widget _buildSectionForm(ProfileState profileState) {
    final currentProfile = profileState.currentProfile;
    final notifier = ref.read(profileControllerProvider.notifier);

    return switch (widget.sectionType) {
      SectionType.personalInfo => PersonalInfoForm(
        nameController: _nameController,
        emailController: _emailController,
        phoneController: _phoneController,
        locationController: _locationController,
        birthDateController: _birthDateController,
        genderController: _genderController,
        photoUrl: currentProfile.photoUrl,
        onPhotoChanged: notifier.updatePhoto,
      ),
      SectionType.experience => ExperienceListForm(
        experiences: currentProfile.experience,
        onChanged: notifier.updateExperience,
      ),
      SectionType.education => EducationListForm(
        education: currentProfile.education,
        onChanged: notifier.updateEducation,
      ),
      SectionType.certifications => CertificationListForm(
        certifications: currentProfile.certifications,
        onChanged: notifier.updateCertifications,
      ),
      SectionType.skills => SkillsInputForm(
        skills: currentProfile.skills,
        onChanged: notifier.updateSkills,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final hasChanges = profileState.hasChanges;

    return PopScope(
      canPop: _canPopNow,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handlePop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Hero(
              tag: 'section_card_${widget.title}',
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.bgColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    24,
                    MediaQuery.of(context).padding.top + 20,
                    24,
                    32,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _handlePop,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: widget.textColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.iconBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.iconColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildSectionForm(profileState),
              ),
            ),
            if (hasChanges) _buildStickySaveBar(profileState.isSaving),
          ],
        ),
      ),
    );
  }

  Widget _buildStickySaveBar(bool isSaving) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: Material(
            color: isSaving
                ? Colors.black.withValues(alpha: 0.5)
                : Colors.black,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: isSaving ? null : _handleSave,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: isSaving
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.saveProfile.toUpperCase(),
                            style: textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
