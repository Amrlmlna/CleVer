import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user_profile.dart';
import '../../profile/providers/profile_provider.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((
  ref,
) {
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

  Map<String, dynamic> toJson() => {
    'currentPage': currentPage,
    'formData': formData.toJson(),
  };

  factory OnboardingState.fromJson(Map<String, dynamic> json) {
    return OnboardingState(
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      formData: UserProfile.fromJson(
        (json['formData'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }

  /// True once the user has entered anything in the panel — drives the
  /// dynamic nav label (lewati vs lanjut) and the close confirmation.
  bool get hasAnyData =>
      formData.fullName.isNotEmpty ||
      formData.email.isNotEmpty ||
      (formData.phoneNumber?.isNotEmpty ?? false) ||
      (formData.location?.isNotEmpty ?? false) ||
      (formData.birthDate?.isNotEmpty ?? false) ||
      (formData.gender?.isNotEmpty ?? false) ||
      formData.experience.isNotEmpty ||
      formData.education.isNotEmpty ||
      formData.skills.isNotEmpty ||
      formData.certifications.isNotEmpty;
}

class OnboardingFormNotifier extends StateNotifier<OnboardingState> {
  final Ref ref;

  OnboardingFormNotifier(this.ref)
    : super(
        OnboardingState(
          currentPage: 0,
          formData: const UserProfile(
            fullName: '',
            email: '',
            experience: [],
            education: [],
            skills: [],
            certifications: [],
          ),
        ),
      ) {
    _restoreDraft();
  }

  static const String _draftKey = 'onboarding_form_draft';

  /// Central mutation point: every change persists a draft so the panel
  /// state survives sheet dismissal and app kills.
  void _commit(OnboardingState next) {
    state = next;
    _persistDraft();
  }

  Future<void> _persistDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_draftKey, jsonEncode(state.toJson()));
  }

  Future<void> _restoreDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null || !mounted) return;
    try {
      state = OnboardingState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt or outdated draft: start fresh.
      await prefs.remove(_draftKey);
    }
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  void updateName(String name) {
    _commit(state.copyWith(formData: state.formData.copyWith(fullName: name)));
  }

  void updateEmail(String email) {
    _commit(state.copyWith(formData: state.formData.copyWith(email: email)));
  }

  void updatePhone(String phone) {
    _commit(
      state.copyWith(formData: state.formData.copyWith(phoneNumber: phone)),
    );
  }

  void updateLocation(String location) {
    _commit(
      state.copyWith(formData: state.formData.copyWith(location: location)),
    );
  }

  void updateBirthDate(String birthDate) {
    _commit(
      state.copyWith(formData: state.formData.copyWith(birthDate: birthDate)),
    );
  }

  void updateGender(String gender) {
    _commit(state.copyWith(formData: state.formData.copyWith(gender: gender)));
  }

  void updateExperience(List<Experience> experience) {
    _commit(
      state.copyWith(formData: state.formData.copyWith(experience: experience)),
    );
  }

  void updateEducation(List<Education> education) {
    _commit(
      state.copyWith(formData: state.formData.copyWith(education: education)),
    );
  }

  void updateSkills(List<Skill> skills) {
    _commit(state.copyWith(formData: state.formData.copyWith(skills: skills)));
  }

  void updateCertifications(List<Certification> certifications) {
    _commit(
      state.copyWith(
        formData: state.formData.copyWith(certifications: certifications),
      ),
    );
  }

  bool nextPage() {
    if (state.currentPage == 0) {
      if (state.formData.fullName.isEmpty) {
        return false;
      }
    }

    if (state.currentPage < 6) {
      _commit(state.copyWith(currentPage: state.currentPage + 1));
      return true;
    }
    return true;
  }

  void populateFromImport(UserProfile profile) {
    _commit(state.copyWith(formData: profile));
  }

  void skipToFinal() {
    _commit(state.copyWith(currentPage: 6));
  }

  void prevPage() {
    if (state.currentPage > 0) {
      _commit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  /// Discards the in-progress panel draft (used by the confirmation sheet's
  /// "discard" action before closing).
  Future<void> discardDraft() async {
    await _clearDraft();
    if (!mounted) return;
    state = OnboardingState(
      currentPage: 0,
      formData: const UserProfile(
        fullName: '',
        email: '',
        experience: [],
        education: [],
        skills: [],
        certifications: [],
      ),
    );
  }

  Future<void> submit() async {
    state = state.copyWith(isSaving: true);

    try {
      await ref
          .read(masterProfileProvider.notifier)
          .saveProfile(state.formData);
      await ref.read(onboardingProvider.notifier).completeOnboarding();
      await _clearDraft();
    } finally {
      if (mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }
}

final onboardingFormProvider =
    StateNotifierProvider.autoDispose<OnboardingFormNotifier, OnboardingState>((
      ref,
    ) {
      return OnboardingFormNotifier(ref);
    });
