import 'package:equatable/equatable.dart';
import 'experience.dart';
import 'education.dart';
import 'certification.dart';

export 'experience.dart';
export 'education.dart';
export 'certification.dart';

class UserProfile extends Equatable {
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? location;
  final List<Experience> experience;
  final List<Education> education;
  final List<String> skills;
  final List<Certification> certifications;
  final String? photoUrl;
  final String? birthDate;
  final String? gender;

  const UserProfile({
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.location,
    this.experience = const [],
    this.education = const [],
    this.skills = const [],
    this.certifications = const [],
    this.photoUrl,
    this.birthDate,
    this.gender,
  });

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? location,
    List<Experience>? experience,
    List<Education>? education,
    List<String>? skills,
    List<Certification>? certifications,
    String? photoUrl,
    String? birthDate,
    String? gender,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      photoUrl: photoUrl ?? this.photoUrl,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'experience': experience.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'skills': skills,
      'certifications': certifications.map((e) => e.toJson()).toList(),
      'photoUrl': photoUrl,
      'birthDate': birthDate,
      'gender': gender,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      experience:
          (json['experience'] as List<dynamic>?)
              ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      education:
          (json['education'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      certifications:
          (json['certifications'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      photoUrl: json['photoUrl'] as String?,
      birthDate: json['birthDate'] as String?,
      gender: json['gender'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    phoneNumber,
    location,
    experience,
    education,
    skills,
    certifications,
    photoUrl,
    birthDate,
    gender,
  ];
}
