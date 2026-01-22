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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
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
            Center(
               child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor, // White in dark mode
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2), 
                    width: 4
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: Icon(Icons.person, size: 50, color: Theme.of(context).scaffoldBackgroundColor), // Inverse Icon color
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'MASTER PROFILE',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: Theme.of(context).colorScheme.onBackground, // White in dark
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Isi sekali, generate berkali-kali.',
               style: TextStyle(color: Colors.grey[400], fontSize: 14),
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
            
            const SizedBox(height: 48),

            const SizedBox(height: 48),

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
    // "Gen Z" Card: Dark surface, no heavy borders, maybe subtle gradient or simple generic dark card
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        // Remove border or make it very subtle for dark mode
        border: isDark 
            ? Border.all(color: Colors.white.withOpacity(0.05))
            : Border.all(color: Colors.grey.shade200),
        boxShadow: isDark ? [] : [
           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: isDark ? Colors.white : Colors.black, size: 20),
        ),
        title: Text(
          title, 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
            fontFamily: 'Outfit', // Ensure font is applied
            fontSize: 16,
          )
        ),
        shape: const Border(), // Remove default border
        childrenPadding: const EdgeInsets.all(16),
        children: [child],
      ),
    );
  }
}
