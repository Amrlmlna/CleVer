import 'package:equatable/equatable.dart';
import 'experience.dart';
import 'education.dart';

export 'experience.dart';
export 'education.dart';

class UserProfile extends Equatable {
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? location;
  final List<Experience> experience;
  final List<Education> education;
  final List<String> skills;

  const UserProfile({
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.location,
    this.experience = const [],
    this.education = const [],
    this.skills = const [],
  });

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? location,
    List<Experience>? experience,
    List<Education>? education,
    List<String>? skills,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
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
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      experience: (json['experience'] as List<dynamic>?)
              ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      education: (json['education'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      skills: (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );
  }

  @override
  List<Object?> get props => [fullName, email, phoneNumber, location, experience, education, skills];
}
