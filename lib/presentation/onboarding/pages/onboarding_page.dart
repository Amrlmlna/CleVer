import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/onboarding_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import '../widgets/onboarding_personal_step.dart';
import '../widgets/onboarding_experience_step.dart';
import '../widgets/onboarding_education_step.dart';
import '../widgets/onboarding_certification_step.dart';
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

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  List<Experience> _experiences = [];
  List<Education> _education = [];
  List<Certification> _certifications = [];
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

    if (_currentPage == 0) {
      if (_nameController.text.isEmpty) {
        CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.fillNameError);
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

  bool _isSaving = false;

  Future<void> _finishOnboarding() async {
    setState(() {
      _isSaving = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final masterProfile = UserProfile(
      fullName: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
      experience: _experiences,
      education: _education,
      certifications: _certifications,
      skills: _skills,
    );
    
    await ref.read(masterProfileProvider.notifier).saveProfile(masterProfile);

    await ref.read(onboardingProvider.notifier).completeOnboarding();
    
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentPage: _currentPage,
      totalSteps: 6,
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey, 
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
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
                  OnboardingCertificationStep(
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
            isLastPage: _currentPage == 5,
            isLoading: _isSaving,
            onNext: _nextPage,
            onBack: _prevPage,
          ),
        ],
      ),
    );
  }
}
