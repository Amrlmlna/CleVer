import '../../../domain/entities/user_profile.dart';
import '../../../core/utils/deduplication_utils.dart';

class ProfileMerger {
  static UserProfile merge(
    UserProfile current,
    UserProfile incoming, {
    bool overwriteExisting = true,
  }) {
    final String newName;
    final String newEmail;
    final String? newPhone;
    final String? newLocation;
    final String? newBirthDate;
    final String? newGender;
    final String? newPhoto;

    if (overwriteExisting) {
      newName = incoming.fullName.isNotEmpty
          ? incoming.fullName
          : current.fullName;
      newEmail = incoming.email.isNotEmpty ? incoming.email : current.email;
      newPhone = incoming.phoneNumber?.isNotEmpty == true
          ? incoming.phoneNumber
          : current.phoneNumber;
      newLocation = incoming.location?.isNotEmpty == true
          ? incoming.location
          : current.location;
      newBirthDate = incoming.birthDate?.isNotEmpty == true
          ? incoming.birthDate
          : current.birthDate;
      newGender = incoming.gender?.isNotEmpty == true
          ? incoming.gender
          : current.gender;
      newPhoto = incoming.photoUrl?.isNotEmpty == true
          ? incoming.photoUrl
          : current.photoUrl;
    } else {
      newName = current.fullName.isEmpty ? incoming.fullName : current.fullName;
      newEmail = current.email.isEmpty ? incoming.email : current.email;
      newPhone = (current.phoneNumber == null || current.phoneNumber!.isEmpty)
          ? incoming.phoneNumber
          : current.phoneNumber;
      newLocation = (current.location == null || current.location!.isEmpty)
          ? incoming.location
          : current.location;
      newBirthDate = (current.birthDate == null || current.birthDate!.isEmpty)
          ? incoming.birthDate
          : current.birthDate;
      newGender = (current.gender == null || current.gender!.isEmpty)
          ? incoming.gender
          : current.gender;
      newPhoto = (current.photoUrl == null || current.photoUrl!.isEmpty)
          ? incoming.photoUrl
          : current.photoUrl;
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

    final List<Experience> mergedExperience = _mergeExperience(
      current.experience,
      incoming.experience,
    );
    final List<Education> mergedEducation = _mergeEducation(
      current.education,
      incoming.education,
    );
    final List<Certification> mergedCertifications = _mergeCertifications(
      current.certifications,
      incoming.certifications,
    );

    final Map<String, Skill> uniqueSkillsMap = {
      for (final s in current.skills) s.name.toLowerCase(): s,
    };
    for (final s in incoming.skills) {
      uniqueSkillsMap.putIfAbsent(s.name.toLowerCase(), () => s);
    }

    return updatedInfo.copyWith(
      experience: mergedExperience,
      education: mergedEducation,
      skills: uniqueSkillsMap.values.toList(),
      certifications: mergedCertifications,
    );
  }

  static List<Experience> _mergeExperience(
    List<Experience> current,
    List<Experience> incoming,
  ) {
    final List<Experience> merged = List.from(current);
    for (final newExp in incoming) {
      int existsIndex = -1;
      for (int i = 0; i < merged.length; i++) {
        final oldExp = merged[i];
        if (newExp.fingerprint != null &&
            oldExp.fingerprint != null &&
            newExp.fingerprint == oldExp.fingerprint) {
          existsIndex = i;
          break;
        }
        if (DeduplicationUtils.normalizeText(oldExp.companyName) ==
                DeduplicationUtils.normalizeText(newExp.companyName) &&
            DeduplicationUtils.normalizeText(oldExp.jobTitle) ==
                DeduplicationUtils.normalizeText(newExp.jobTitle) &&
            DeduplicationUtils.normalizeDate(oldExp.startDate) ==
                DeduplicationUtils.normalizeDate(newExp.startDate)) {
          existsIndex = i;
          break;
        }
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
        final oldExp = merged[existsIndex];
        merged[existsIndex] = oldExp.copyWith(
          description: newExp.description.length > oldExp.description.length
              ? newExp.description
              : oldExp.description,
        );
      } else {
        merged.add(newExp);
      }
    }
    return merged;
  }

  static List<Education> _mergeEducation(
    List<Education> current,
    List<Education> incoming,
  ) {
    final List<Education> merged = List.from(current);
    for (final newEdu in incoming) {
      int existsIndex = -1;
      for (int i = 0; i < merged.length; i++) {
        final oldEdu = merged[i];
        if (newEdu.fingerprint != null &&
            oldEdu.fingerprint != null &&
            newEdu.fingerprint == oldEdu.fingerprint) {
          existsIndex = i;
          break;
        }
        if (DeduplicationUtils.normalizeText(oldEdu.schoolName) ==
                DeduplicationUtils.normalizeText(newEdu.schoolName) &&
            DeduplicationUtils.normalizeText(oldEdu.degree) ==
                DeduplicationUtils.normalizeText(newEdu.degree) &&
            DeduplicationUtils.normalizeDate(oldEdu.startDate) ==
                DeduplicationUtils.normalizeDate(newEdu.startDate)) {
          existsIndex = i;
          break;
        }
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
        final oldEdu = merged[existsIndex];
        merged[existsIndex] = oldEdu.copyWith(
          gpa: newEdu.gpa ?? oldEdu.gpa,
          subjects: newEdu.subjects.length > oldEdu.subjects.length
              ? newEdu.subjects
              : oldEdu.subjects,
          description: newEdu.description.length > oldEdu.description.length
              ? newEdu.description
              : oldEdu.description,
        );
      } else {
        merged.add(newEdu);
      }
    }
    return merged;
  }

  static List<Certification> _mergeCertifications(
    List<Certification> current,
    List<Certification> incoming,
  ) {
    final List<Certification> merged = List.from(current);
    for (final newCert in incoming) {
      bool exists = false;
      for (final oldCert in merged) {
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
      if (!exists) merged.add(newCert);
    }
    return merged;
  }
}
