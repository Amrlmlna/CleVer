import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile.dart';

// Provides the "Master" profile data (persisted across sessions)
final masterProfileProvider = StateNotifierProvider<MasterProfileNotifier, UserProfile?>((ref) {
  return MasterProfileNotifier();
});

class MasterProfileNotifier extends StateNotifier<UserProfile?> {
  MasterProfileNotifier({UserProfile? initialState}) : super(initialState);

  static const String _key = 'master_profile_data';

  Future<void> saveProfile(UserProfile profile) async {
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
}
