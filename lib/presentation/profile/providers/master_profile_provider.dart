import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/utils/profile_merger.dart';

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
    final mergedProfile = ProfileMerger.merge(current, newProfile);

    if (mergedProfile != current) {
      print("[DEBUG] Profile updated via merge!");
      await saveProfile(mergedProfile);
      return true;
    }

    return false;
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
