import 'package:equatable/equatable.dart';
import 'user_profile.dart'; // Import existing entities

class CVData extends Equatable {
  final String id;
  final UserProfile userProfile;
  final String generatedSummary;
  final List<String> tailoredSkills;
  final String styleId;
  final DateTime createdAt;

  const CVData({
    required this.id,
    required this.userProfile,
    required this.generatedSummary,
    required this.tailoredSkills,
    required this.styleId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userProfile': userProfile.toJson(),
      'generatedSummary': generatedSummary,
      'tailoredSkills': tailoredSkills,
      'styleId': styleId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CVData.fromJson(Map<String, dynamic> json) {
    return CVData(
      id: json['id'] as String,
      userProfile: UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
      generatedSummary: json['generatedSummary'] as String,
      tailoredSkills: (json['tailoredSkills'] as List<dynamic>).map((e) => e as String).toList(),
      styleId: json['styleId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, userProfile, generatedSummary, tailoredSkills, styleId, createdAt];
}
