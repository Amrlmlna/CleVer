import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
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
    
    // 1. Personal Info - Explicit Check
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

    // 5. Certifications - Add only NEW items
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

  /// Pick and save profile image
  Future<String?> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
      return savedImage.path;
    }
    return null;
  }

  Future<void> clearProfile() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
