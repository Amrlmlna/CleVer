import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/personal_info_form.dart';
import '../widgets/experience_list_form.dart';
import '../widgets/education_list_form.dart';
import '../widgets/skills_input_form.dart';
import '../widgets/section_card.dart';
import '../widgets/profile_header.dart';

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
    // Debug print
    // debugPrint("ProfilePage: Loading from provider. Data: $masterProfile");
    
    if (masterProfile != null) {
      _nameController.text = masterProfile.fullName;
      _emailController.text = masterProfile.email;
      _phoneController.text = masterProfile.phoneNumber ?? '';
      _locationController.text = masterProfile.location ?? '';
      
      setState(() {
        _experience = List.from(masterProfile.experience);
        _education = List.from(masterProfile.education);
        _skills = List.from(masterProfile.skills);
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

  void _saveProfile() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi nama dulu dong')),
      );
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
    );

    ref.read(masterProfileProvider.notifier).saveProfile(newProfile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil Disimpan! Bakal dipake buat CV-mu selanjutnya.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes ensures sync even if page is alive in background
    ref.listen(masterProfileProvider, (prev, next) {
      if (prev != next) { // Equatable ensures this works correctly
        _loadFromProvider();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const ProfileHeader(),
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
              title: 'Skill',
              icon: Icons.code,
              child: SkillsInputForm(
                skills: _skills,
                onChanged: (val) => setState(() => _skills = val),
              ),
            ),

            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.check),
                label: const Text('Simpan Profil'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
