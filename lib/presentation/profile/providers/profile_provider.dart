import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user_profile.dart';
import '../../auth/providers/auth_state_provider.dart';

final masterProfileProvider = StateNotifierProvider<MasterProfileNotifier, UserProfile?>((ref) {
  return MasterProfileNotifier();
});

class MasterProfileNotifier extends StateNotifier<UserProfile?> {
  late Future<void> _initFuture;

  MasterProfileNotifier({UserProfile? initialState}) 
      : super(initialState) {
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
    
    final newName = newProfile.fullName.isNotEmpty ? newProfile.fullName : current.fullName;
    final newEmail = newProfile.email.isNotEmpty ? newProfile.email : current.email;
    final newPhone = newProfile.phoneNumber?.isNotEmpty == true ? newProfile.phoneNumber : current.phoneNumber;
    final newLocation = newProfile.location?.isNotEmpty == true ? newProfile.location : current.location;
    
    if (newName != current.fullName || 
        newEmail != current.email || 
        newPhone != current.phoneNumber || 
        newLocation != current.location) {
      print("[DEBUG] Personal Info Changed!");
      hasChanges = true;
    }

    final updatedInfo = current.copyWith(
      fullName: newName,
      email: newEmail,
      phoneNumber: newPhone,
      location: newLocation,
    );

    final List<Experience> mergedExperience = List.from(current.experience);
    for (final newExp in newProfile.experience) {
       final exists = mergedExperience.any((oldExp) => 
          oldExp.jobTitle.toLowerCase() == newExp.jobTitle.toLowerCase() &&
          oldExp.companyName.toLowerCase() == newExp.companyName.toLowerCase() && 
          oldExp.startDate == newExp.startDate
       );
       
       if (!exists) {
         mergedExperience.add(newExp);
         hasChanges = true;
       }
    }

    final List<Education> mergedEducation = List.from(current.education);
    for (final newEdu in newProfile.education) {
       final exists = mergedEducation.any((oldEdu) => 
          oldEdu.schoolName.toLowerCase() == newEdu.schoolName.toLowerCase() &&
          oldEdu.degree.toLowerCase() == newEdu.degree.toLowerCase()
       );
       
       if (!exists) {
         mergedEducation.add(newEdu);
         hasChanges = true;
       }
    }

    final Set<String> uniqueSkills = Set.from(current.skills);
    final initialSkillCount = uniqueSkills.length;
    uniqueSkills.addAll(newProfile.skills);
    
    if (uniqueSkills.length != initialSkillCount) {
      hasChanges = true;
    }

    final List<Certification> mergedCertifications = List.from(current.certifications);
    for (final newCert in newProfile.certifications) {
       final exists = mergedCertifications.any((oldCert) => 
          oldCert.name.toLowerCase() == newCert.name.toLowerCase() &&
          oldCert.issuer.toLowerCase() == newCert.issuer.toLowerCase()
       );
       
       if (!exists) {
         mergedCertifications.add(newCert);
         hasChanges = true;
       }
    }
    
    if (hasChanges) {
      final finalProfile = updatedInfo.copyWith(
        experience: mergedExperience,
        education: mergedEducation,
        skills: uniqueSkills.toList(),
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
    final current = state ?? const UserProfile(
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
  
  void updateSkills(List<String> skills) {
     if (state == null) return;
     final updated = state!.copyWith(skills: skills);
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
      : super(ProfileState(
          initialProfile: null,
          currentProfile: const UserProfile(
            fullName: '',
            email: '',
            experience: [],
            education: [],
            skills: [],
            certifications: [],
          ),
        )) {
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
           state = state.copyWith(
            initialProfile: next,
            currentProfile: next,
          );
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

  void updateSkills(List<String> skills) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(skills: skills),
    );
  }

  void updateCertifications(List<Certification> certifications) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(certifications: certifications),
    );
  }

  void importProfile(UserProfile importedProfile) {
    final current = state.currentProfile;
    
    final newProfile = current.copyWith(
      fullName: current.fullName.isEmpty ? importedProfile.fullName : current.fullName,
      email: current.email.isEmpty ? importedProfile.email : current.email,
      phoneNumber: (current.phoneNumber == null || current.phoneNumber!.isEmpty) 
          ? importedProfile.phoneNumber 
          : current.phoneNumber,
      location: (current.location == null || current.location!.isEmpty)
          ? importedProfile.location
          : current.location,
      experience: [...current.experience, ...importedProfile.experience],
      education: [...current.education, ...importedProfile.education],
      skills: {...current.skills, ...importedProfile.skills}.toList(),
      certifications: [...current.certifications, ...importedProfile.certifications],
    );

    state = state.copyWith(currentProfile: newProfile);
  }

  Future<bool> saveProfile() async {
    if (state.currentProfile.fullName.isEmpty) {
      return false;
    }

    state = state.copyWith(isSaving: true);
    try {
      await ref.read(masterProfileProvider.notifier).saveProfile(state.currentProfile);
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

  Future<void> deleteAccount() async {
    // TODO: Implement fresh account deletion logic
  }

  void discardChanges() {
    state = state.copyWith(
      currentProfile: state.initialProfile,
    );
  }
}

final profileControllerProvider = StateNotifierProvider.autoDispose<ProfileController, ProfileState>((ref) {
  return ProfileController(ref);
});
