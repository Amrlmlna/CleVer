import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/entities/certification.dart'; // Import
import '../providers/onboarding_provider.dart';
import '../../profile/providers/profile_provider.dart';

import '../widgets/onboarding_personal_step.dart';
import '../widgets/onboarding_experience_step.dart';
import '../widgets/onboarding_education_step.dart';
import '../widgets/onboarding_certification_step.dart'; // Import
import '../widgets/onboarding_skills_step.dart';
import '../widgets/onboarding_final_step.dart';
import '../widgets/onboarding_shell.dart';
import '../widgets/onboarding_navigation_bar.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();

  // Data State
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  List<Experience> _experiences = [];
  List<Education> _education = [];
  List<Certification> _certifications = []; // Add
  List<String> _skills = [];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    // Validation Logic
    if (_currentPage == 0) {
      if (_nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tolong isi nama lengkap dulu ya.'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 120, left: 20, right: 20), // Higher margin for Onboarding Nav
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }
    }

    // Increased total steps to 6 (0-5)
    if (_currentPage < 5) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {
        _currentPage++;
      });
    } else {
      _finishOnboarding();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {
        _currentPage--;
      });
    }
  }

  bool _isSaving = false;

  Future<void> _finishOnboarding() async {
    setState(() {
      _isSaving = true;
    });

    // Artificial delay to show off the premium animation
    await Future.delayed(const Duration(seconds: 2));

    // 1. Save to Master Profile
    final masterProfile = UserProfile(
      fullName: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
      experience: _experiences,
      education: _education,
      certifications: _certifications, // Save
      skills: _skills,
    );
    
    await ref.read(masterProfileProvider.notifier).saveProfile(masterProfile);

    // 2. Mark Onboarding as Complete
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    
    // 3. Navigate Home
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentPage: _currentPage,
      totalSteps: 6, // Update Total Steps
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey, 
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Prevent swipe
                children: [
                  OnboardingPersonalStep(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    locationController: _locationController,
                  ),
                  OnboardingExperienceStep(
                    experiences: _experiences,
                    onChanged: (val) => setState(() => _experiences = val),
                  ),
                  OnboardingEducationStep(
                    education: _education,
                    onChanged: (val) => setState(() => _education = val),
                  ),
                  OnboardingCertificationStep( // Add Step
                    certifications: _certifications,
                    onChanged: (val) => setState(() => _certifications = val),
                  ),
                  OnboardingSkillsStep(
                    skills: _skills,
                    onChanged: (val) => setState(() => _skills = val),
                  ),
                  const OnboardingFinalStep(),
                ],
              ),
            ),
          ),

          OnboardingNavigationBar(
            currentPage: _currentPage,
            isLastPage: _currentPage == 5, // Update Last Page Index
            isLoading: _isSaving, // Pass Loading State
            onNext: _nextPage,
            onBack: _prevPage,
          ),
        ],
      ),
    );
  }
}
