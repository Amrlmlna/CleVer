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
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();

    _nameController.addListener(() => ref.read(onboardingFormProvider.notifier).updateName(_nameController.text));
    _emailController.addListener(() => ref.read(onboardingFormProvider.notifier).updateEmail(_emailController.text));
    _phoneController.addListener(() => ref.read(onboardingFormProvider.notifier).updatePhone(_phoneController.text));
    _locationController.addListener(() => ref.read(onboardingFormProvider.notifier).updateLocation(_locationController.text));
  }

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
    final notifier = ref.read(onboardingFormProvider.notifier);
    
    // Validate locally for UI feedback if needed, but provider handles logic
    if (ref.read(onboardingFormProvider).currentPage == 0) {
       if (_nameController.text.isEmpty) {
        CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.fillNameError);
        return;
      }
    }

    if (notifier.nextPage()) {
      // Animation handled by listener
    } else {
       // Handle validation failure if provider returns false
    }
  }

  void _prevPage() {
    ref.read(onboardingFormProvider.notifier).prevPage();
  }

  Future<void> _finishOnboarding() async {
     await ref.read(onboardingFormProvider.notifier).submit();
     if (mounted) {
       context.go('/');
     }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingFormProvider);
    final currentPage = state.currentPage;
    final isSaving = state.isSaving;
    
    // Listen to page changes to animate
    ref.listen(onboardingFormProvider, (prev, next) {
      if (prev?.currentPage != next.currentPage) {
        _pageController.animateToPage(
          next.currentPage, 
          duration: const Duration(milliseconds: 300), 
          curve: Curves.easeInOut
        );
      }
    });

    return OnboardingShell(
      currentPage: currentPage,
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
                    experiences: state.formData.experience,
                    onChanged: (val) => ref.read(onboardingFormProvider.notifier).updateExperience(val),
                  ),
                  OnboardingEducationStep(
                    education: state.formData.education,
                    onChanged: (val) => ref.read(onboardingFormProvider.notifier).updateEducation(val),
                  ),
                  OnboardingCertificationStep(
                    certifications: state.formData.certifications,
                    onChanged: (val) => ref.read(onboardingFormProvider.notifier).updateCertifications(val),
                  ),
                  OnboardingSkillsStep(
                    skills: state.formData.skills,
                    onChanged: (val) => ref.read(onboardingFormProvider.notifier).updateSkills(val),
                  ),
                  const OnboardingFinalStep(),
                ],
              ),
            ),
          ),

          OnboardingNavigationBar(
            currentPage: currentPage,
            isLastPage: currentPage == 5,
            isLoading: isSaving,
            onNext: currentPage < 5 ? _nextPage : _finishOnboarding,
            onBack: _prevPage,
          ),
        ],
      ),
    );
  }
}
