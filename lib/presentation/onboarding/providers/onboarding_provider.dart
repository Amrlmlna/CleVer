import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/analytics_service.dart';
import '../../../domain/entities/user_profile.dart';
import '../../profile/providers/profile_provider.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier({bool initialState = false}) : super(initialState); 

  static const String _key = 'onboarding_completed';

  Future<void> checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_key) ?? false;
    state = completed;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    state = true;
    
    AnalyticsService().trackEvent('onboarding_completed');
  }
}

class OnboardingState {
  final int currentPage;
  final UserProfile formData;
  final bool isSaving;

  OnboardingState({
    required this.currentPage,
    required this.formData,
    this.isSaving = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    UserProfile? formData,
    bool? isSaving,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      formData: formData ?? this.formData,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class OnboardingFormNotifier extends StateNotifier<OnboardingState> {
  final Ref ref;

  OnboardingFormNotifier(this.ref)
      : super(OnboardingState(
          currentPage: 0,
          formData: const UserProfile(
            fullName: '',
            email: '',
            experience: [],
            education: [],
            skills: [],
            certifications: [],
          ),
        ));

  void updateName(String name) {
    state = state.copyWith(
      formData: state.formData.copyWith(fullName: name),
    );
  }

  void updateEmail(String email) {
    state = state.copyWith(
      formData: state.formData.copyWith(email: email),
    );
  }

  void updatePhone(String phone) {
    state = state.copyWith(
      formData: state.formData.copyWith(phoneNumber: phone),
    );
  }

  void updateLocation(String location) {
    state = state.copyWith(
      formData: state.formData.copyWith(location: location),
    );
  }

  void updateExperience(List<Experience> experience) {
    state = state.copyWith(
      formData: state.formData.copyWith(experience: experience),
    );
  }

  void updateEducation(List<Education> education) {
    state = state.copyWith(
      formData: state.formData.copyWith(education: education),
    );
  }

  void updateSkills(List<String> skills) {
    state = state.copyWith(
      formData: state.formData.copyWith(skills: skills),
    );
  }

  void updateCertifications(List<Certification> certifications) {
    state = state.copyWith(
      formData: state.formData.copyWith(certifications: certifications),
    );
  }

  bool nextPage() {
    if (state.currentPage == 0) {
      if (state.formData.fullName.isEmpty) {
        return false; 
      }
    }

    if (state.currentPage < 5) {
      state = state.copyWith(currentPage: state.currentPage + 1);
      return true;
    }
    return true;
  }

  void prevPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  Future<void> submit() async {
    state = state.copyWith(isSaving: true);
    
    await Future.delayed(const Duration(seconds: 2));

    try {
      await ref.read(masterProfileProvider.notifier).saveProfile(state.formData);
      await ref.read(onboardingProvider.notifier).completeOnboarding();
      
    } finally {
      if (mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }
}

final onboardingFormProvider = StateNotifierProvider.autoDispose<OnboardingFormNotifier, OnboardingState>((ref) {
  return OnboardingFormNotifier(ref);
});
