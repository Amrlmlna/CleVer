import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:go_router/go_router.dart';

import '../../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/personal_info_form.dart';
import '../widgets/experience_list_form.dart';
import '../widgets/education_list_form.dart';
import '../widgets/skills_input_form.dart';
import '../widgets/certification_list_form.dart'; // Import
import '../widgets/section_card.dart';
import '../widgets/profile_header.dart';
import '../providers/cv_import_provider.dart';
import '../../common/widgets/app_loading_screen.dart';

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
  List<Certification> _certifications = []; // Add state
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
        _certifications = List.from(masterProfile.certifications); // Load
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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _profileImagePath = savedImage.path;
      });
    }
  }

  void _showImportCVDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import CV'),
        content: const Text('Pilih cara import CV kamu:'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _importFromImage(ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Kamera'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _importFromImage(ImageSource.gallery);
            },
            icon: const Icon(Icons.photo_library),
            label: const Text('Galeri'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _importFromPDF();
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('File PDF'),
          ),
        ],
      ),
    );
  }

  Future<void> _importFromImage(ImageSource source) async {
    bool loadingShown = false;

    final result = await ref.read(cvImportProvider.notifier).importFromImage(
      source,
      onProcessingStart: () {
        if (!loadingShown && mounted) {
          loadingShown = true;
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: false,
              pageBuilder: (context, _, __) => const AppLoadingScreen(
                badge: "IMPORTING CV",
                messages: [
                  "Membaca CV...",
                  "Mengekstrak data...",
                  "Menyusun profil...",
                ],
              ),
            ),
          );
        }
      },
    );

    if (mounted && loadingShown) {
      Navigator.pop(context);
    }

    _handleImportResult(result.status, result.extractedProfile);
  }

  Future<void> _importFromPDF() async {
    bool loadingShown = false;

    final result = await ref.read(cvImportProvider.notifier).importFromPDF(
      onProcessingStart: () {
        if (!loadingShown && mounted) {
          loadingShown = true;
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: false,
              pageBuilder: (context, _, __) => const AppLoadingScreen(
                badge: "IMPORTING CV",
                messages: [
                  "Membaca PDF...",
                  "Mengekstrak data...",
                  "Menyusun profil...",
                ],
              ),
            ),
          );
        }
      },
    );

    if (mounted && loadingShown) {
      Navigator.pop(context);
    }

    _handleImportResult(result.status, result.extractedProfile);
  }

  void _handleImportResult(CVImportStatus status, UserProfile? profile) {
    switch (status) {
      case CVImportStatus.success:
        if (profile != null) {
          // MERGE imported data with existing data (don't replace!)
          
          // Update text fields only if they're currently empty
          if (_nameController.text.isEmpty) {
            _nameController.text = profile.fullName;
          }
          if (_emailController.text.isEmpty) {
            _emailController.text = profile.email;
          }
          if (_phoneController.text.isEmpty && profile.phoneNumber != null) {
            _phoneController.text = profile.phoneNumber!;
          }
          if (_locationController.text.isEmpty && profile.location != null) {
            _locationController.text = profile.location!;
          }
          
          setState(() {
            // ADD imported items to existing lists (merge, don't replace!)
            _experience = [..._experience, ...profile.experience];
            _education = [..._education, ...profile.education];
            
            // For skills, merge and remove duplicates
            final allSkills = {..._skills, ...profile.skills}.toList();
            _skills = allSkills;
            
            // Add certifications
            _certifications = [..._certifications, ...profile.certifications];
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ CV berhasil diimport!\n'
                'Ditambahkan: ${profile.experience.length} pengalaman, '
                '${profile.education.length} pendidikan, '
                '${profile.skills.length} skill'
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        break;
      case CVImportStatus.cancelled:
        // User cancelled, do nothing
        break;
      case CVImportStatus.noText:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Tidak ada teks yang ditemukan di CV'),
            backgroundColor: Colors.orange,
          ),
        );
        break;
      case CVImportStatus.error:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Gagal mengimport CV. Coba lagi ya!'),
            backgroundColor: Colors.red,
          ),
        );
        break;
      default:
        break;
    }
  }

  void _saveProfile() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Isi nama dulu dong'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
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
      certifications: _certifications, // Save
      profilePicturePath: _profileImagePath,
    );

    ref.read(masterProfileProvider.notifier).saveProfile(newProfile);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profil Disimpan! Bakal dipake buat CV-mu selanjutnya.'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20), // Avoid Floating Button
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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

              // Import CV Button
              ElevatedButton.icon(
                onPressed: _showImportCVDialog,
                icon: const Icon(Icons.upload_file),
                label: const Text('Import dari CV yang udah ada'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
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
              title: 'Sertifikasi', // New Section
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

            const SizedBox(height: 48),
            
            // Save Button
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
            
            // Help Button (New Placement)
            Center(
              child: TextButton.icon(
                onPressed: () => context.push('/profile/help'),
                icon: Icon(Icons.help_outline, color: Theme.of(context).disabledColor),
                label: Text(
                  'Bantuan & Dukungan',
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
            ),
            
            const SizedBox(height: 100), // Extra bottom padding
          ],
        ),
      ),
      ),
    );
  }
}
