import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/onboarding_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../widgets/onboarding_welcome_step.dart';
import '../widgets/onboarding_personal_step.dart';
import '../widgets/onboarding_experience_step.dart';
import '../widgets/onboarding_education_step.dart';
import '../widgets/onboarding_skills_step.dart';
import '../widgets/onboarding_final_step.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();

  // Temporary State for data collection
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  List<Experience> _experiences = [];
  List<Education> _education = [];
  List<String> _skills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentPage + 1) / 6,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
            
            Expanded(
              child: Form(
                key: _formKey, // Used mainly for personal info validation
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Prevent swipe
                  children: [
                    const OnboardingWelcomeStep(),
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
                    OnboardingSkillsStep(
                      skills: _skills,
                      onChanged: (val) => setState(() => _skills = val),
                    ),
                    const OnboardingFinalStep(),
                  ],
                ),
              ),
            ),
            
            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _prevPage,
                      child: const Text('Back', style: TextStyle(color: Colors.grey)),
                    )
                  else
                    const SizedBox(width: 80), // Spacer

                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_currentPage == 5 ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    // Validation Logic
    if (_currentPage == 1) {
      if (_nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your name.')));
        return;
      }
    }

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

  Future<void> _finishOnboarding() async {
    // 1. Save to Master Profile
    final masterProfile = UserProfile(
      fullName: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
      experience: _experiences,
      education: _education,
      skills: _skills,
    );
    
    ref.read(masterProfileProvider.notifier).saveProfile(masterProfile);

    // 2. Mark Onboarding as Complete
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    
    // 3. Navigate Home
    if (mounted) {
      context.go('/');
    }
  }
}
