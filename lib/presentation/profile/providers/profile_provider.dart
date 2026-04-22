import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../core/utils/deduplication_utils.dart';
import '../../auth/providers/auth_state_provider.dart';

final masterProfileProvider =
    StateNotifierProvider<MasterProfileNotifier, UserProfile?>((ref) {
      return MasterProfileNotifier();
    });

class MasterProfileNotifier extends StateNotifier<UserProfile?> {
  late Future<void> _initFuture;

  MasterProfileNotifier({UserProfile? initialState}) : super(initialState) {
    _initFuture = loadProfile();
  }

  static const String _key = 'master_profile_data';

  Future<void> saveProfile(UserProfile profile) async {
    await _initFuture;
    state = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(profile.toJson()));
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      state = UserProfile.fromJson(jsonDecode(jsonString));
    } else {
      state = null;
    }
  }

  Future<bool> mergeProfile(UserProfile newProfile) async {
    if (state == null) {
      await saveProfile(newProfile);
      return true;
    }

    final current = state!;
    bool hasChanges = false;

    final newName = newProfile.fullName.isNotEmpty
        ? newProfile.fullName
        : current.fullName;
    final newEmail = newProfile.email.isNotEmpty
        ? newProfile.email
        : current.email;
    final newPhone = newProfile.phoneNumber?.isNotEmpty == true
        ? newProfile.phoneNumber
        : current.phoneNumber;
    final newLocation = newProfile.location?.isNotEmpty == true
        ? newProfile.location
        : current.location;
    final newBirthDate = newProfile.birthDate?.isNotEmpty == true
        ? newProfile.birthDate
        : current.birthDate;
    final newGender = newProfile.gender?.isNotEmpty == true
        ? newProfile.gender
        : current.gender;
    final newPhoto = newProfile.photoUrl?.isNotEmpty == true
        ? newProfile.photoUrl
        : current.photoUrl;

    if (newName != current.fullName ||
        newEmail != current.email ||
        newPhone != current.phoneNumber ||
        newLocation != current.location ||
        newBirthDate != current.birthDate ||
        newGender != current.gender ||
        newPhoto != current.photoUrl) {
      print("[DEBUG] Personal Info Changed (including photo)!");
      hasChanges = true;
    }

    final updatedInfo = current.copyWith(
      fullName: newName,
      email: newEmail,
      phoneNumber: newPhone,
      location: newLocation,
      birthDate: newBirthDate,
      gender: newGender,
      photoUrl: newPhoto,
    );

    final List<Experience> mergedExperience = List.from(current.experience);
    for (final newExp in newProfile.experience) {
      int existsIndex = -1;
      for (int i = 0; i < mergedExperience.length; i++) {
        final oldExp = mergedExperience[i];
        // 1. Fingerprint Match
        if (newExp.fingerprint != null &&
            oldExp.fingerprint != null &&
            newExp.fingerprint == oldExp.fingerprint) {
          existsIndex = i;
          break;
        }

        // 2. Identity Match
        if (DeduplicationUtils.normalizeText(oldExp.companyName) ==
                DeduplicationUtils.normalizeText(newExp.companyName) &&
            DeduplicationUtils.normalizeText(oldExp.jobTitle) ==
                DeduplicationUtils.normalizeText(newExp.jobTitle) &&
            DeduplicationUtils.normalizeDate(oldExp.startDate) ==
                DeduplicationUtils.normalizeDate(newExp.startDate)) {
          existsIndex = i;
          break;
        }

        // 3. Fuzzy Match
        if (DeduplicationUtils.isFuzzyMatch(oldExp.jobTitle, newExp.jobTitle) &&
            DeduplicationUtils.isFuzzyMatch(
              oldExp.companyName,
              newExp.companyName,
            )) {
          existsIndex = i;
          break;
        }
      }

      if (existsIndex != -1) {
        final oldExp = mergedExperience[existsIndex];
        final updatedExp = oldExp.copyWith(
          description: (newExp.description?.length ?? 0) > (oldExp.description?.length ?? 0)
              ? newExp.description
              : oldExp.description,
        );
        if (updatedExp != oldExp) {
          mergedExperience[existsIndex] = updatedExp;
          hasChanges = true;
        }
      } else {
        mergedExperience.add(newExp);
        hasChanges = true;
      }
    }

    final List<Education> mergedEducation = List.from(current.education);
    for (final newEdu in newProfile.education) {
      int existsIndex = -1;
      for (int i = 0; i < mergedEducation.length; i++) {
        final oldEdu = mergedEducation[i];
        // 1. Fingerprint Match
        if (newEdu.fingerprint != null &&
            oldEdu.fingerprint != null &&
            newEdu.fingerprint == oldEdu.fingerprint) {
          existsIndex = i;
          break;
        }

        // 2. Identity Match
        if (DeduplicationUtils.normalizeText(oldEdu.schoolName) ==
                DeduplicationUtils.normalizeText(newEdu.schoolName) &&
            DeduplicationUtils.normalizeText(oldEdu.degree) ==
                DeduplicationUtils.normalizeText(newEdu.degree) &&
            DeduplicationUtils.normalizeDate(oldEdu.startDate) ==
                DeduplicationUtils.normalizeDate(newEdu.startDate)) {
          existsIndex = i;
          break;
        }

        // 3. Fuzzy Match
        if (DeduplicationUtils.isFuzzyMatch(oldEdu.degree, newEdu.degree) &&
            DeduplicationUtils.isFuzzyMatch(
              oldEdu.schoolName,
              newEdu.schoolName,
            )) {
          existsIndex = i;
          break;
        }
      }

      if (existsIndex != -1) {
        final oldEdu = mergedEducation[existsIndex];
        final updatedEdu = oldEdu.copyWith(
          gpa: newEdu.gpa ?? oldEdu.gpa,
          subjects: newEdu.subjects.length > oldEdu.subjects.length ? newEdu.subjects : oldEdu.subjects,
          description: (newEdu.description?.length ?? 0) > (oldEdu.description?.length ?? 0)
              ? newEdu.description
              : oldEdu.description,
        );
        if (updatedEdu != oldEdu) {
          mergedEducation[existsIndex] = updatedEdu;
          hasChanges = true;
        }
      } else {
        mergedEducation.add(newEdu);
        hasChanges = true;
      }
    }

    final Map<String, Skill> uniqueSkillsMap = {
      for (final s in current.skills) s.name.toLowerCase(): s,
    };
    final initialSkillCount = uniqueSkillsMap.length;
    for (final s in newProfile.skills) {
      uniqueSkillsMap.putIfAbsent(s.name.toLowerCase(), () => s);
    }

    if (uniqueSkillsMap.length != initialSkillCount) {
      hasChanges = true;
    }

    final List<Certification> mergedCertifications = List.from(
      current.certifications,
    );
    for (final newCert in newProfile.certifications) {
      bool exists = false;

      for (final oldCert in mergedCertifications) {
        // 1. Fingerprint Match
        if (newCert.fingerprint != null &&
            oldCert.fingerprint != null &&
            newCert.fingerprint == oldCert.fingerprint) {
          exists = true;
          break;
        }

        // 2. Identity Match (Name + Issuer + Date)
        if (DeduplicationUtils.normalizeText(oldCert.name) ==
                DeduplicationUtils.normalizeText(newCert.name) &&
            DeduplicationUtils.normalizeText(oldCert.issuer) ==
                DeduplicationUtils.normalizeText(newCert.issuer) &&
            DeduplicationUtils.normalizeDate(oldCert.date.toIso8601String()) ==
                DeduplicationUtils.normalizeDate(
                  newCert.date.toIso8601String(),
                )) {
          exists = true;
          break;
        }

        // 3. Fuzzy Match (Name + Issuer)
        if (DeduplicationUtils.isFuzzyMatch(oldCert.name, newCert.name) &&
            DeduplicationUtils.isFuzzyMatch(oldCert.issuer, newCert.issuer)) {
          // If names are fuzzy matches, also check if dates are close
          if (DeduplicationUtils.normalizeDate(
                oldCert.date.toIso8601String(),
              ) ==
              DeduplicationUtils.normalizeDate(
                newCert.date.toIso8601String(),
              )) {
            exists = true;
            break;
          }
        }
      }

      if (!exists) {
        mergedCertifications.add(newCert);
        hasChanges = true;
      }
    }

    if (hasChanges) {
      final finalProfile = updatedInfo.copyWith(
        experience: mergedExperience,
        education: mergedEducation,
        skills: uniqueSkillsMap.values.toList(),
        certifications: mergedCertifications,
      );
      await saveProfile(finalProfile);
    }

    return hasChanges;
  }

  void updatePersonalInfo({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String location,
  }) {
    final current =
        state ??
        const UserProfile(
          fullName: '',
          email: '',
          experience: [],
          education: [],
          skills: [],
        );

    final updated = current.copyWith(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      location: location,
    );
    saveProfile(updated);
  }

  void updateExperience(List<Experience> experience) {
    if (state == null) return;
    final updated = state!.copyWith(experience: experience);
    saveProfile(updated);
  }

  void updateEducation(List<Education> education) {
    if (state == null) return;
    final updated = state!.copyWith(education: education);
    saveProfile(updated);
  }

  void updateSkills(List<Skill> skills) {
    if (state == null) return;
    final updated = state!.copyWith(skills: skills);
    saveProfile(updated);
  }

  void updatePhoto(String? photoUrl) {
    if (state == null) return;
    final updated = state!.copyWith(photoUrl: photoUrl);
    saveProfile(updated);
  }

  Future<void> clearProfile() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

// --- Profile Controller & State ---

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
          state = state.copyWith(initialProfile: next);
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
    final current = state.currentProfile;

    final List<Experience> dedupedExp = List.from(current.experience);
    for (final newExp in importedProfile.experience) {
      bool exists = false;
      for (final oldExp in dedupedExp) {
        if (newExp.fingerprint != null &&
            oldExp.fingerprint != null &&
            newExp.fingerprint == oldExp.fingerprint) {
          exists = true;
          break;
        }
        if (DeduplicationUtils.normalizeText(oldExp.companyName) ==
                DeduplicationUtils.normalizeText(newExp.companyName) &&
            DeduplicationUtils.normalizeText(oldExp.jobTitle) ==
                DeduplicationUtils.normalizeText(newExp.jobTitle) &&
            DeduplicationUtils.normalizeDate(oldExp.startDate) ==
                DeduplicationUtils.normalizeDate(newExp.startDate)) {
          exists = true;
          break;
        }
        if (DeduplicationUtils.isFuzzyMatch(oldExp.jobTitle, newExp.jobTitle) &&
            DeduplicationUtils.isFuzzyMatch(
              oldExp.companyName,
              newExp.companyName,
            )) {
          exists = true;
          break;
        }
      }
      if (!exists) dedupedExp.add(newExp);
    }

    final List<Education> dedupedEdu = List.from(current.education);
    for (final newEdu in importedProfile.education) {
      bool exists = false;
      for (final oldEdu in dedupedEdu) {
        if (newEdu.fingerprint != null &&
            oldEdu.fingerprint != null &&
            newEdu.fingerprint == oldEdu.fingerprint) {
          exists = true;
          break;
        }
        if (DeduplicationUtils.normalizeText(oldEdu.schoolName) ==
                DeduplicationUtils.normalizeText(newEdu.schoolName) &&
            DeduplicationUtils.normalizeText(oldEdu.degree) ==
                DeduplicationUtils.normalizeText(newEdu.degree) &&
            DeduplicationUtils.normalizeDate(oldEdu.startDate) ==
                DeduplicationUtils.normalizeDate(newEdu.startDate)) {
          exists = true;
          break;
        }
        if (DeduplicationUtils.isFuzzyMatch(oldEdu.degree, newEdu.degree) &&
            DeduplicationUtils.isFuzzyMatch(
              oldEdu.schoolName,
              newEdu.schoolName,
            )) {
          exists = true;
          break;
        }
      }
      if (!exists) dedupedEdu.add(newEdu);
    }

    final List<Certification> dedupedCert = List.from(current.certifications);
    for (final newCert in importedProfile.certifications) {
      bool exists = false;
      for (final oldCert in dedupedCert) {
        if (newCert.fingerprint != null &&
            oldCert.fingerprint != null &&
            newCert.fingerprint == oldCert.fingerprint) {
          exists = true;
          break;
        }
        if (DeduplicationUtils.normalizeText(oldCert.name) ==
                DeduplicationUtils.normalizeText(newCert.name) &&
            DeduplicationUtils.normalizeText(oldCert.issuer) ==
                DeduplicationUtils.normalizeText(newCert.issuer) &&
            DeduplicationUtils.normalizeDate(oldCert.date.toIso8601String()) ==
                DeduplicationUtils.normalizeDate(
                  newCert.date.toIso8601String(),
                )) {
          exists = true;
          break;
        }
        if (DeduplicationUtils.isFuzzyMatch(oldCert.name, newCert.name) &&
            DeduplicationUtils.isFuzzyMatch(oldCert.issuer, newCert.issuer)) {
          if (DeduplicationUtils.normalizeDate(
                oldCert.date.toIso8601String(),
              ) ==
              DeduplicationUtils.normalizeDate(
                newCert.date.toIso8601String(),
              )) {
            exists = true;
            break;
          }
        }
      }
      if (!exists) dedupedCert.add(newCert);
    }

    final newProfile = current.copyWith(
      fullName: current.fullName.isEmpty
          ? importedProfile.fullName
          : current.fullName,
      email: current.email.isEmpty ? importedProfile.email : current.email,
      phoneNumber: (current.phoneNumber == null || current.phoneNumber!.isEmpty)
          ? importedProfile.phoneNumber
          : current.phoneNumber,
      location: (current.location == null || current.location!.isEmpty)
          ? importedProfile.location
          : current.location,
      birthDate: (current.birthDate == null || current.birthDate!.isEmpty)
          ? importedProfile.birthDate
          : current.birthDate,
      gender: (current.gender == null || current.gender!.isEmpty)
          ? importedProfile.gender
          : current.gender,
      experience: dedupedExp,
      education: dedupedEdu,
      skills: {...current.skills, ...importedProfile.skills}.toList(),
      certifications: dedupedCert,
    );

    state = state.copyWith(currentProfile: newProfile);
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
      state = state.copyWith(
        initialProfile: state.currentProfile,
        isSaving: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false);
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
    } finally {
      state = state.copyWith(isSaving: false);
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
