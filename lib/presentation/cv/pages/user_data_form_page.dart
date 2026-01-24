import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/cv_generation_provider.dart';
import '../../profile/providers/profile_provider.dart';
// Widgets
import '../widgets/form/user_data_form_content.dart';

import '../../../domain/entities/tailored_cv_result.dart'; // import

class UserDataFormPage extends ConsumerStatefulWidget {
  final TailoredCVResult? tailoredResult; // Changed from UserProfile
  const UserDataFormPage({super.key, this.tailoredResult});

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
  
  // Summary Controller
  final _summaryController = TextEditingController();
  bool _isGeneratingSummary = false;
  
  // Lists
  List<Experience> _experience = [];
  List<Education> _education = [];
  List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    // Auto-fill from Master Profile if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final masterProfile = ref.read(masterProfileProvider);
      final creationState = ref.read(cvCreationProvider);
      
      final profileToUse = widget.tailoredResult?.profile ?? masterProfile;
      final isTailored = widget.tailoredResult != null;
      
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

        // Pre-fill summary
        // Priority: Passed Result > Saved State
        final initialSummary = widget.tailoredResult?.summary ?? creationState.summary;
        if (initialSummary != null) {
          _summaryController.text = initialSummary;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isTailored 
              ? 'Data & Summary telah disesuaikan oleh AI! ✨' 
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
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _generateSummary() async {
    final jobInput = ref.read(cvCreationProvider).jobInput;
    if (jobInput == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Job Input missing')));
      return;
    }

    setState(() {
      _isGeneratingSummary = true;
    });

    try {
      // Use existing generateCV to get summary
      // We pass current form data as temporary profile
      final currentProfile = UserProfile(
        fullName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        location: _locationController.text,
        experience: _experience,
        education: _education,
        skills: _skills,
      );

      final repository = ref.read(cvRepositoryProvider);
      final cvData = await repository.generateCV(
        profile: currentProfile,
        jobInput: jobInput,
        styleId: 'ATS', // Dummy style
        language: ref.read(cvCreationProvider).language,
      );

      if (mounted) {
        setState(() {
          _summaryController.text = cvData.summary;
          _isGeneratingSummary = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGeneratingSummary = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal generate summary: $e')));
      }
    }
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

      // Save Profile
      ref.read(cvCreationProvider.notifier).setUserProfile(profile);
      
      // Save Summary
      ref.read(cvCreationProvider.notifier).setSummary(_summaryController.text);
      
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
              color: Colors.black.withValues(alpha: 0.1),
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
            'Lanjut: Pilih Template',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: UserDataFormContent(
        formKey: _formKey,
        isDark: isDark,
        tailoredResult: widget.tailoredResult,
        nameController: _nameController,
        emailController: _emailController,
        phoneController: _phoneController,
        locationController: _locationController,
        summaryController: _summaryController,
        isGeneratingSummary: _isGeneratingSummary,
        experience: _experience,
        education: _education,
        skills: _skills,
        updateMasterProfile: _updateMasterProfile,
        onGenerateSummary: _generateSummary,
        onExperienceChanged: (val) => setState(() => _experience = val),
        onEducationChanged: (val) => setState(() => _education = val),
        onSkillsChanged: (val) => setState(() => _skills = val),
        onUpdateMasterProfileChanged: (val) => setState(() => _updateMasterProfile = val ?? true),
      ),
    );
  }
}
