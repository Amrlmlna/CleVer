import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_profile.dart';
import 'profile_provider.dart';

class ProfileFormState {
  final bool isSaving;
  final bool hasUnsavedChanges;

  ProfileFormState({
    required this.isSaving,
    required this.hasUnsavedChanges,
  });

  ProfileFormState copyWith({
    bool? isSaving,
    bool? hasUnsavedChanges,
  }) {
    return ProfileFormState(
      isSaving: isSaving ?? this.isSaving,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }
}

class ProfileFormNotifier extends StateNotifier<ProfileFormState> {
  ProfileFormNotifier() : super(ProfileFormState(isSaving: false, hasUnsavedChanges: false));

  void setSaving(bool value) => state = state.copyWith(isSaving: value);
  void setHasChanges(bool value) => state = state.copyWith(hasUnsavedChanges: value);
}

final profileFormStateProvider = StateNotifierProvider<ProfileFormNotifier, ProfileFormState>((ref) {
  return ProfileFormNotifier();
});
