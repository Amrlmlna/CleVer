import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_profile.dart';
import '../../drafts/providers/draft_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'dart:math';

String calculateUserLevel(UserProfile? profile, List<dynamic> drafts) {
  int score = 0;

  if (profile == null) {
    return "Rookie Job Seeker";
  }

  final completion = calculateProfileCompletion(profile);
  score += (completion * 4).round();

  score += min(drafts.length * 10, 300);

  score += min(profile.experience.length * 20, 300);

  if (score < 350) return "Rookie Job Seeker";
  if (score < 750) return "Mid-Level Professional";
  return "Expert Career Builder";
}

int calculateProfileCompletion(UserProfile? profile) {
  if (profile == null) return 0;

  int completed = 0;
  int total = 6;

  if (profile.fullName.isNotEmpty) completed++;
  if (profile.email.isNotEmpty) completed++;
  if (profile.phoneNumber != null && profile.phoneNumber!.isNotEmpty)
    completed++;

  if (profile.experience.isNotEmpty) completed++;

  if (profile.education.isNotEmpty) completed++;

  if (profile.skills.isNotEmpty) completed++;

  if (profile.certifications.isNotEmpty) completed++;

  return ((completed / total) * 100).round();
}

/// Classifies profile completeness into 3 states for feedback purposes.
/// Used primarily in onboarding step 7/7 to provide contextual feedback.
///
/// - **complete**: 3+ core sections filled (experience, education, skills, certifications)
/// - **partial**: 1-2 core sections filled
/// - **empty**: No core sections filled (only name/email from step 1)
String classifyProfileCompleteness(UserProfile? profile) {
  if (profile == null) return 'empty';

  int coreSectionsFilled = 0;

  if (profile.experience.isNotEmpty) coreSectionsFilled++;
  if (profile.education.isNotEmpty) coreSectionsFilled++;
  if (profile.skills.isNotEmpty) coreSectionsFilled++;
  if (profile.certifications.isNotEmpty) coreSectionsFilled++;

  if (coreSectionsFilled >= 3) return 'complete';
  if (coreSectionsFilled >= 1) return 'partial';
  return 'empty';
}

final userLevelProvider = Provider<String>((ref) {
  final profile = ref.watch(masterProfileProvider);
  final draftsAsync = ref.watch(draftsProvider);

  final drafts = draftsAsync.when(
    data: (data) => data,
    loading: () => [],
    error: (_, __) => [],
  );

  return calculateUserLevel(profile, drafts);
});
