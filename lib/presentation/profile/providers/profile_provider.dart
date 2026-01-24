import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user_profile.dart';

// Provides the "Master" profile data (persisted across sessions)
final masterProfileProvider = StateNotifierProvider<MasterProfileNotifier, UserProfile?>((ref) {
  return MasterProfileNotifier();
});

class MasterProfileNotifier extends StateNotifier<UserProfile?> {
  late Future<void> _initFuture;

  MasterProfileNotifier({UserProfile? initialState}) : super(initialState) {
    _initFuture = loadProfile();
  }

  static const String _key = 'master_profile_data';

  Future<void> saveProfile(UserProfile profile) async {
    // Wait for any pending load to finish so we don't get overwritten
    await _initFuture;
    state = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(profile.toJson()));
  }

  // Method to manually re-load if needed (e.g. after clear)
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      state = UserProfile.fromJson(jsonDecode(jsonString));
    } else {
      state = null;
    }
  }

  /// Merges new profile data into the existing Master Profile.
  /// 
  /// Returns `true` if any data was actually updated/added, `false` otherwise.
  Future<bool> mergeProfile(UserProfile newProfile) async {
    if (state == null) {
      await saveProfile(newProfile);
      return true;
    }

    final current = state!;
    bool hasChanges = false;
    
    // 1. Personal Info - Check for changes
    final updatedInfo = current.copyWith(
      fullName: newProfile.fullName.isNotEmpty ? newProfile.fullName : current.fullName,
      email: newProfile.email.isNotEmpty ? newProfile.email : current.email,
      phoneNumber: newProfile.phoneNumber?.isNotEmpty == true ? newProfile.phoneNumber : current.phoneNumber,
      location: newProfile.location?.isNotEmpty == true ? newProfile.location : current.location,
    );
    
    // Basic equality check involves checking individual fields because copyWith might technically create a new object even if values are same
    if (updatedInfo != current) {
      hasChanges = true;
    }

    // 2. Experience - Add only NEW items
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

    // 3. Education - Add only NEW items
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

    // 4. Skills - Union
    final Set<String> uniqueSkills = Set.from(current.skills);
    final initialSkillCount = uniqueSkills.length;
    uniqueSkills.addAll(newProfile.skills);
    
    if (uniqueSkills.length != initialSkillCount) {
      hasChanges = true;
    }
    
    if (hasChanges) {
      final finalProfile = updatedInfo.copyWith(
        experience: mergedExperience,
        education: mergedEducation,
        skills: uniqueSkills.toList(),
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
