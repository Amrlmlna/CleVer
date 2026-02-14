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
  
  bool _isInit = true;
  bool _isSaving = false;

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
    if (masterProfile == null) {
      // If no profile, we have changes if any field is not empty
      return _nameController.text.isNotEmpty ||
          _emailController.text.isNotEmpty ||
          _phoneController.text.isNotEmpty ||
          _locationController.text.isNotEmpty ||
          _experience.isNotEmpty ||
          _education.isNotEmpty ||
          _skills.isNotEmpty ||
          _certifications.isNotEmpty;
    }

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

    return currentLocal != masterProfile;
  }

  Future<bool> _showExitWarning() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Simpan Perubahan?'),
        content: const Text('Kamu punya perubahan yang belum disimpan. Yakin mau keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Leave anyway
            child: const Text('Keluar Tanpa Simpan', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false), // Stay
            child: const Text('Tetap di Sini'),
          ),
        ],
      ),
    );
    return result ?? false;
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
    );

    setState(() => _isSaving = true);

    try {
      ref.read(masterProfileProvider.notifier).saveProfile(newProfile);
      
      if (mounted) {
        CustomSnackBar.showSuccess(context, 'Profil Disimpan! Bakal dipake buat CV-mu selanjutnya.');
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, 'Gagal simpan profil: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(masterProfileProvider, (prev, next) {
      if (prev != next) {
        _loadFromProvider();
      }
    });

    return Scaffold(
      body: PopScope(
        canPop: !_hasChanges() || _isSaving,
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
              canSave: _hasChanges() && !_isSaving,
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }
}
