import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/personal_info_form.dart';
import '../widgets/experience_list_form.dart';
import '../widgets/education_list_form.dart';
import '../widgets/skills_input_form.dart';
import '../widgets/certification_list_form.dart';
import '../widgets/section_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/import_cv_button.dart';
import '../widgets/profile_action_buttons.dart';
import '../../../core/utils/custom_snackbar.dart';

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
  String? _profileImagePath;
  
  bool _isInit = true;

  @override
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
        _profileImagePath = masterProfile.profilePicturePath;
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
         _profileImagePath = null;
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

  Future<void> _pickImage() async {
    final imagePath = await ref.read(masterProfileProvider.notifier).pickProfileImage();
    if (imagePath != null) {
      setState(() {
        _profileImagePath = imagePath;
      });
    }
  }

  void _handleImportSuccess(UserProfile importedProfile) {
    // MERGE imported data with existing data (don't replace!)
    
    // Update text fields only if they're currently empty
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
      // ADD imported items to existing lists (merge, don't replace!)
      _experience = [..._experience, ...importedProfile.experience];
      _education = [..._education, ...importedProfile.education];
      
      // For skills, merge and remove duplicates
      final allSkills = {..._skills, ...importedProfile.skills}.toList();
      _skills = allSkills;
      
      // Add certifications
      _certifications = [..._certifications, ...importedProfile.certifications];
    });

    CustomSnackBar.showSuccess(
      context,
      'CV berhasil diimport!\n'
      'Ditambahkan: ${importedProfile.experience.length} pengalaman, '
      '${importedProfile.education.length} pendidikan, '
      '${importedProfile.skills.length} skill',
    );
  }

  void _saveProfile() {
    if (_nameController.text.isEmpty) {
      CustomSnackBar.showWarning(context, 'Isi nama dulu dong');
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
      profilePicturePath: _profileImagePath,
    );

    ref.read(masterProfileProvider.notifier).saveProfile(newProfile);

    CustomSnackBar.showSuccess(context, 'Profil Disimpan! Bakal dipake buat CV-mu selanjutnya.');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(masterProfileProvider, (prev, next) {
      if (prev != next) {
        _loadFromProvider();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              ProfileHeader(
                imagePath: _profileImagePath,
                onEditImage: _pickImage,
              ),
              const SizedBox(height: 24),

              // Import CV Button (Extracted Widget)
              ImportCVButton(
                onImportSuccess: _handleImportSuccess,
              ),

              const SizedBox(height: 32),

            SectionCard(
              title: 'Info Personal',
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
              title: 'Pengalaman Kerja',
              icon: Icons.work_outline,
              child: ExperienceListForm(
                experiences: _experience,
                onChanged: (val) => setState(() => _experience = val),
              ),
            ),

            const SizedBox(height: 24),

            SectionCard(
              title: 'Pendidikan',
              icon: Icons.school_outlined,
              child: EducationListForm(
                education: _education,
                onChanged: (val) => setState(() => _education = val),
              ),
            ),

            const SizedBox(height: 24),

            SectionCard(
              title: 'Sertifikasi',
              icon: Icons.card_membership,
              child: CertificationListForm(
                certifications: _certifications,
                onChanged: (val) => setState(() => _certifications = val),
              ),
            ),

            const SizedBox(height: 24),

            SectionCard(
              title: 'Skill',
              icon: Icons.code,
              child: SkillsInputForm(
                skills: _skills,
                onChanged: (val) => setState(() => _skills = val),
              ),
            ),

            // Action Buttons (Extracted Widget)
            ProfileActionButtons(
              onSave: _saveProfile,
            ),
          ],
        ),
      ),
      ),
    );
  }
}
