import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/onboarding_provider.dart';
import '../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import '../widgets/onboarding_personal_step.dart';
import '../widgets/onboarding_import_step.dart';
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
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _birthDateController = TextEditingController();
    _genderController = TextEditingController();

    _nameController.addListener(
      () => ref
          .read(onboardingFormProvider.notifier)
          .updateName(_nameController.text),
    );
    _emailController.addListener(
      () => ref
          .read(onboardingFormProvider.notifier)
          .updateEmail(_emailController.text),
    );
    _phoneController.addListener(
      () => ref
          .read(onboardingFormProvider.notifier)
          .updatePhone(_phoneController.text),
    );
    _locationController.addListener(
      () => ref
          .read(onboardingFormProvider.notifier)
          .updateLocation(_locationController.text),
    );
    _birthDateController.addListener(
      () => ref
          .read(onboardingFormProvider.notifier)
          .updateBirthDate(_birthDateController.text),
    );
    _genderController.addListener(
      () => ref
          .read(onboardingFormProvider.notifier)
          .updateGender(_genderController.text),
    );

    _prefillFromAuth();
  }

  void _prefillFromAuth() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        _nameController.text = user.displayName!;
      }
      if (user.email != null && user.email!.isNotEmpty) {
        _emailController.text = user.email!;
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final notifier = ref.read(onboardingFormProvider.notifier);

    if (ref.read(onboardingFormProvider).currentPage == 0) {
      if (_nameController.text.isEmpty) {
        CustomSnackBar.showWarning(
          context,
          AppLocalizations.of(context)!.fillNameError,
        );
        return;
      }
    }

    if (notifier.nextPage()) {
    } else {}
  }

  void _prevPage() {
    ref.read(onboardingFormProvider.notifier).prevPage();
  }

  void _handleImportSuccess(profile) {
    final notifier = ref.read(onboardingFormProvider.notifier);

    notifier.populateFromImport(profile);

    _nameController.text = profile.fullName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber ?? '';
    _locationController.text = profile.location ?? '';
    _birthDateController.text = profile.birthDate ?? '';
    _genderController.text = profile.gender ?? '';

    notifier.skipToFinal();

    if (mounted) {
      CustomSnackBar.showSuccess(
        context,
        AppLocalizations.of(context)!.cvImportedSuccess,
      );
    }
  }

  void _handleManualEntry() {
    ref.read(onboardingFormProvider.notifier).nextPage();
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

    final bool isImportStep = currentPage == 1;
    final bool isLastPage = currentPage == 6;

    final bool isSkippable = currentPage >= 2 && currentPage <= 5;

    ref.listen(onboardingFormProvider, (prev, next) {
      if (prev?.currentPage != next.currentPage) {
        _pageController.animateToPage(
          next.currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return OnboardingShell(
      currentPage: currentPage,
      totalSteps: 7,
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
                    birthDateController: _birthDateController,
                    genderController: _genderController,
                  ),
                  OnboardingImportStep(
                    onManualEntry: _handleManualEntry,
                    onImportSuccess: _handleImportSuccess,
                  ),
                  OnboardingExperienceStep(
                    experiences: state.formData.experience,
                    onChanged: (val) => ref
                        .read(onboardingFormProvider.notifier)
                        .updateExperience(val),
                  ),
                  OnboardingEducationStep(
                    education: state.formData.education,
                    onChanged: (val) => ref
                        .read(onboardingFormProvider.notifier)
                        .updateEducation(val),
                  ),
                  OnboardingCertificationStep(
                    certifications: state.formData.certifications,
                    onChanged: (val) => ref
                        .read(onboardingFormProvider.notifier)
                        .updateCertifications(val),
                  ),
                  OnboardingSkillsStep(
                    skills: state.formData.skills,
                    onChanged: (val) => ref
                        .read(onboardingFormProvider.notifier)
                        .updateSkills(val),
                  ),
                  const OnboardingFinalStep(),
                ],
              ),
            ),
          ),

          if (!isImportStep)
            OnboardingNavigationBar(
              currentPage: currentPage,
              isLastPage: isLastPage,
              isLoading: isSaving,
              onNext: currentPage < 6 ? _nextPage : _finishOnboarding,
              onBack: _prevPage,
              isSkippable: isSkippable,
              onSkip: isSkippable ? _nextPage : null,
            ),
        ],
      ),
    );
  }
}
