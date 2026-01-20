import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/personal_info_form.dart';
import '../widgets/experience_list_form.dart';
import '../widgets/education_list_form.dart';
import '../widgets/skills_input_form.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // Local controllers for immediate editing, synced with provider on Save
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
      final masterProfile = ref.read(masterProfileProvider);
      if (masterProfile != null) {
        _nameController.text = masterProfile.fullName;
        _emailController.text = masterProfile.email;
        _phoneController.text = masterProfile.phoneNumber ?? '';
        _locationController.text = masterProfile.location ?? '';
        _experience = List.from(masterProfile.experience);
        _education = List.from(masterProfile.education);
        _skills = List.from(masterProfile.skills);
      }
      _isInit = false;
    }
  }

    void _saveProfile() {
    // Validate?
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi nama dulu dong')),
      );
      return;
    }

    final newProfile = UserProfile(
      // id: 'master', // Removed
      fullName: _nameController.text, // 59
      email: _emailController.text, // 60
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
            const Center(
               child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Isi sekali, pake berkali-kali.',
               style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 32),

            // 1. Personal Info
            _SectionCard(
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

            // 2. Experience
            _SectionCard(
              title: 'Pengalaman Kerja',
              icon: Icons.work_outline,
              child: ExperienceListForm(
                experiences: _experience,
                onChanged: (val) {
                  setState(() {
                    _experience = val;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // 3. Education
            _SectionCard(
              title: 'Pendidikan',
              icon: Icons.school_outlined,
              child: EducationListForm(
                education: _education,
                onChanged: (val) {
                  setState(() {
                    _education = val;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // 4. Skills
            _SectionCard(
              title: 'Skill',
              icon: Icons.code,
              child: SkillsInputForm(
                skills: _skills,
                onChanged: (val) {
                  setState(() {
                    _skills = val;
                  });
                },
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
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () async {
                   // Reset logic for testing
                   final prefs = await SharedPreferences.getInstance();
                   await prefs.setBool('onboarding_completed', false);
                   
                   if (context.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Onboarding Reset! Restart app to see it again.')),
                     );
                   }
                },
                child: const Text('Reset Onboarding (Debug)', style: TextStyle(color: Colors.red)),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        shape: const Border(), // Remove default border
        childrenPadding: const EdgeInsets.all(16),
        children: [child],
      ),
    );
  }
}
