import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/utils/profile_merger.dart';
import '../../auth/providers/auth_state_provider.dart';
import './master_profile_provider.dart';
import './profile_state.dart';
import './profile_sync_provider.dart';

class ProfileController extends StateNotifier<ProfileState> {
  final Ref ref;

  ProfileController(this.ref)
    : super(
        ProfileState(
          initialProfile: null,
          currentProfile: const UserProfile(
            fullName: '',
            email: '',
            experience: [],
            education: [],
            skills: [],
            certifications: [],
          ),
        ),
      ) {
    _init();
  }

  void _init() {
    final masterProfile = ref.read(masterProfileProvider);
    if (masterProfile != null) {
      state = ProfileState(
        initialProfile: masterProfile,
        currentProfile: masterProfile,
      );
    }

    ref.listen(masterProfileProvider, (previous, next) {
      if (next != null && next != state.initialProfile) {
        if (!state.hasChanges) {
          state = state.copyWith(initialProfile: next, currentProfile: next);
        } else {
          // IMPORTANT: If photo changed in Master Profile, propagate it even if there are unsaved text changes
          if (next.photoUrl != state.currentProfile.photoUrl) {
            state = state.copyWith(
              initialProfile: next,
              currentProfile: state.currentProfile.copyWith(
                photoUrl: next.photoUrl,
              ),
            );
          } else {
            state = state.copyWith(initialProfile: next);
          }
        }
      }
    });
  }

  void updateName(String name) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(fullName: name),
    );
  }

  void updateEmail(String email) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(email: email),
    );
  }

  void updatePhone(String phone) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(phoneNumber: phone),
    );
  }

  void updateLocation(String location) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(location: location),
    );
  }

  void updateBirthDate(String birthDate) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(birthDate: birthDate),
    );
  }

  void updateGender(String gender) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(gender: gender),
    );
  }

  void updateExperience(List<Experience> experience) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(experience: experience),
    );
  }

  void updateEducation(List<Education> education) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(education: education),
    );
  }

  void updateSkills(List<Skill> skills) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(skills: skills),
    );
  }

  void updateCertifications(List<Certification> certifications) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(
        certifications: certifications,
      ),
    );
  }

  void updatePhoto(String? photoUrl) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(photoUrl: photoUrl),
    );
  }

  void importProfile(UserProfile importedProfile) {
    final mergedProfile = ProfileMerger.merge(
      state.currentProfile,
      importedProfile,
      overwriteExisting: false,
    );

    state = state.copyWith(currentProfile: mergedProfile);
  }

  Future<bool> saveProfile() async {
    if (state.currentProfile.fullName.isEmpty) {
      return false;
    }

    state = state.copyWith(isSaving: true);
    try {
      await ref
          .read(masterProfileProvider.notifier)
          .saveProfile(state.currentProfile);

      // Trigger immediate cloud sync after saving local master profile
      await ref.read(profileSyncProvider).syncProfileNow();

      if (mounted) {
        state = state.copyWith(
          initialProfile: state.currentProfile,
          isSaving: false,
        );
      }
      return true;
    } catch (e) {
      if (mounted) {
        state = state.copyWith(isSaving: false);
      }
      rethrow;
    }
  }

  Future<void> deleteAccount({required bool keepLocalData}) async {
    state = state.copyWith(isSaving: true);
    try {
      await ref.read(authRepositoryProvider).deleteAccount();

      if (!keepLocalData) {
        await ref.read(masterProfileProvider.notifier).clearProfile();
      }

      if (mounted) {
        state = state.copyWith(
          initialProfile: keepLocalData ? state.initialProfile : null,
          currentProfile: keepLocalData
              ? state.currentProfile
              : const UserProfile(
                  fullName: '',
                  email: '',
                  experience: [],
                  education: [],
                  skills: [],
                  certifications: [],
                ),
        );
      }
    } finally {
      if (mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }

  void discardChanges() {
    state = state.copyWith(currentProfile: state.initialProfile);
  }
}

final profileControllerProvider =
    StateNotifierProvider.autoDispose<ProfileController, ProfileState>((ref) {
      return ProfileController(ref);
    });
