import 'package:equatable/equatable.dart';
import 'user_profile.dart';

class CVData extends Equatable {
  final String id;
  final UserProfile userProfile;
  final String summary;
  final String styleId;
  final DateTime createdAt;
  final String jobTitle;
  final String jobDescription;

  const CVData({
    required this.id,
    required this.userProfile,
    required this.summary,
    required this.styleId,
    required this.createdAt,
    required this.jobTitle,
    this.jobDescription = '',
  });

  CVData copyWith({
    String? id,
    UserProfile? userProfile,
    String? summary,
    String? styleId,
    DateTime? createdAt,
    String? jobTitle,
    String? jobDescription,
  }) {
    return CVData(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      summary: summary ?? this.summary,
      styleId: styleId ?? this.styleId,
      createdAt: createdAt ?? this.createdAt,
      jobTitle: jobTitle ?? this.jobTitle,
      jobDescription: jobDescription ?? this.jobDescription,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userProfile': userProfile.toJson(),
      'summary': summary,
      'styleId': styleId,
      'createdAt': createdAt.toIso8601String(),
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
    };
  }

  factory CVData.fromJson(Map<String, dynamic> json) {
    return CVData(
      id: json['id'] as String,
      userProfile: UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
      summary: (json['summary'] ?? json['generatedSummary']) as String? ?? 'Summary not available',
      styleId: json['styleId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      jobTitle: json['jobTitle'] as String? ?? 'Untitled Job',
      jobDescription: json['jobDescription'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, userProfile, summary, styleId, createdAt, jobTitle, jobDescription];
}
