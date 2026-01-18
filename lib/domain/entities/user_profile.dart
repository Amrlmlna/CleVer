import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [fullName, email, phoneNumber, location, experience, education, skills];
}

class Experience extends Equatable {
  final String jobTitle;
  final String companyName;
  final String startDate; // Simplified for now
  final String? endDate;
  final String description;

  const Experience({
    required this.jobTitle,
    required this.companyName,
    required this.startDate,
    this.endDate,
    required this.description,
  });

  @override
  List<Object?> get props => [jobTitle, companyName, startDate, endDate, description];
}

class Education extends Equatable {
  final String degree;
  final String schoolName;
  final String startDate;
  final String? endDate;

  const Education({
    required this.degree,
    required this.schoolName,
    required this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [degree, schoolName, startDate, endDate];
}
