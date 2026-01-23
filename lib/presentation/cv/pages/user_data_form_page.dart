import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/cv_generation_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../profile/widgets/education_list_form.dart';
import '../../profile/widgets/experience_list_form.dart';
import '../../profile/widgets/skills_input_form.dart';
import '../../profile/widgets/personal_info_form.dart';
import '../widgets/tailored_data_header.dart';
import '../widgets/review_section_card.dart';

class UserDataFormPage extends ConsumerStatefulWidget {
  final UserProfile? tailoredProfile;
  const UserDataFormPage({super.key, this.tailoredProfile});

  @override
  ConsumerState<UserDataFormPage> createState() => _UserDataFormPageState();
}

class _UserDataFormPageState extends ConsumerState<UserDataFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _updateMasterProfile = true;

  // Personal Info Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  
  // Lists
  List<Experience> _experience = [];
  List<Education> _education = [];
  List<String> _skills = [];

  // Accordion State
  bool _isPersonalExpanded = true;
  bool _isExperienceExpanded = false;
  bool _isEducationExpanded = false;
  bool _isSkillsExpanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-fill from Master Profile if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final masterProfile = ref.read(masterProfileProvider);
      final profileToUse = widget.tailoredProfile ?? masterProfile;
      final isTailored = widget.tailoredProfile != null;
      
      if (!mounted) return;

      if (profileToUse != null && _nameController.text.isEmpty) {
        setState(() {
          _nameController.text = profileToUse.fullName;
          _emailController.text = profileToUse.email;
          _phoneController.text = profileToUse.phoneNumber ?? '';
          _locationController.text = profileToUse.location ?? '';
          
          _experience = List<Experience>.from(profileToUse.experience);
          _education = List<Education>.from(profileToUse.education);
          _skills = List<String>.from(profileToUse.skills);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isTailored 
              ? 'Data telah disesuaikan oleh AI untuk pekerjaan ini! ✨' 
              : 'Data otomatis diisi dari Master Profile kamu!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        fullName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        location: _locationController.text,
        experience: _experience,
        education: _education,
        skills: _skills.isNotEmpty ? _skills : ['Leadership', 'Communication'], 
      );

      ref.read(cvCreationProvider.notifier).setUserProfile(profile);
      
      // Smart Save Logic: Only update Master Profile if checking enabled AND data actually changed
      if (_updateMasterProfile) {
         final currentMaster = ref.read(masterProfileProvider);
         
         // Equatable makes this comparison easy and deep
         if (currentMaster != profile) {
            ref.read(masterProfileProvider.notifier).saveProfile(profile);
            
            // UI Fix: Floating SnackBar with margin to avoid button overlap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Master Profile berhasil diupdate!'),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24), // Float high above button
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
         } else {
           // Debug: Data identical, skipping save
           // print("DEBUG: Profile data unchanged, skipping save.");
         }
      }

      context.push('/create/style-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Data'),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.black, 
            foregroundColor: isDark ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Generate CV Sekarang',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header Message
              if (widget.tailoredProfile != null)
                TailoredDataHeader(isDark: isDark),

              // 1. Personal Info Section
              ReviewSectionCard(
                title: 'Informasi Personal',
                icon: Icons.person_outline,
                isExpanded: _isPersonalExpanded,
                onExpansionChanged: (val) {}, // No setState to prevent jank
                 child: PersonalInfoForm(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    locationController: _locationController,
                  ),
              ),
              const SizedBox(height: 16),

              // 2. Experience Section
              ReviewSectionCard(
                title: 'Pengalaman Kerja',
                icon: Icons.work_outline,
                isExpanded: _isExperienceExpanded,
                onExpansionChanged: (val) {},
                child: ExperienceListForm(
                    experiences: _experience,
                    onChanged: (val) => setState(() => _experience = val),
                  ),
              ),
              const SizedBox(height: 16),

              // 3. Education Section
              ReviewSectionCard(
                title: 'Riwayat Pendidikan',
                icon: Icons.school_outlined,
                isExpanded: _isEducationExpanded,
                onExpansionChanged: (val) {},
                   child: EducationListForm(
                    education: _education,
                    onChanged: (val) => setState(() => _education = val),
                  ),
              ),
              const SizedBox(height: 16),

              // 4. Skills Section
              ReviewSectionCard(
                title: 'Keahlian (Skills)',
                icon: Icons.lightbulb_outline,
                isExpanded: _isSkillsExpanded,
                onExpansionChanged: (val) {},
                child: Column(
                    children: [
                      SkillsInputForm(
                        skills: _skills,
                        onChanged: (val) => setState(() => _skills = val),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
                        ),
                        child: CheckboxListTile(
                          title: Text('Update Master Profile', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                          subtitle: Text('Simpan perubahan ini ke profil utamamu.', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey)),
                          value: _updateMasterProfile, 
                          activeColor: isDark ? Colors.white : Colors.black,
                          checkColor: isDark ? Colors.black : Colors.white,
                          onChanged: (val) {
                            setState(() {
                              _updateMasterProfile = val ?? true;
                            });
                          },
                          secondary: Icon(Icons.save_as_outlined, color: isDark ? Colors.white70 : Colors.black54),
                        ),
                      ),
                    ],
                  ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
