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

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'companyName': companyName,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      jobTitle: json['jobTitle'] as String,
      companyName: json['companyName'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      description: json['description'] as String,
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'schoolName': schoolName,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'] as String,
      schoolName: json['schoolName'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
    );
  }

  @override
  List<Object?> get props => [degree, schoolName, startDate, endDate];
}
