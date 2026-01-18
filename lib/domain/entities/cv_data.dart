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

  @override
  List<Object?> get props => [id, userProfile, generatedSummary, tailoredSkills, styleId, createdAt];
}
