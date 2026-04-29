import '../../../domain/entities/user_profile.dart';

class ProfileState {
  final UserProfile? initialProfile;
  final UserProfile currentProfile;
  final bool isSaving;

  ProfileState({
    required this.initialProfile,
    required this.currentProfile,
    this.isSaving = false,
  });

  bool get hasChanges {
    if (initialProfile == null) {
      return currentProfile.fullName.isNotEmpty ||
          currentProfile.email.isNotEmpty ||
          (currentProfile.phoneNumber?.isNotEmpty ?? false) ||
          (currentProfile.location?.isNotEmpty ?? false) ||
          currentProfile.experience.isNotEmpty ||
          currentProfile.education.isNotEmpty ||
          currentProfile.skills.isNotEmpty ||
          currentProfile.certifications.isNotEmpty;
    }
    return initialProfile != currentProfile;
  }

  ProfileState copyWith({
    UserProfile? initialProfile,
    UserProfile? currentProfile,
    bool? isSaving,
  }) {
    return ProfileState(
      initialProfile: initialProfile ?? this.initialProfile,
      currentProfile: currentProfile ?? this.currentProfile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
