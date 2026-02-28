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


final profileStatsProvider = Provider<Map<String, int>>((ref) {
  final profile = ref.watch(masterProfileProvider);
  final draftsAsync = ref.watch(draftsProvider);

  final cvCount = draftsAsync.when(
    data: (data) => data.length,
    loading: () => 0,
    error: (_, __) => 0,
  );

  return {
    'cvCount': cvCount,
    'experienceCount': profile?.experience.length ?? 0,
    'educationCount': profile?.education.length ?? 0,
    'skillsCount': profile?.skills.length ?? 0,
  };
});

final weeklyActivityProvider = Provider<List<int>>((ref) {
  final draftsAsync = ref.watch(draftsProvider);

  return draftsAsync.when(
    data: (drafts) {
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeek = DateTime(monday.year, monday.month, monday.day);
      final endOfWeek = startOfWeek.add(const Duration(days: 7));

      final activity = List<int>.filled(7, 0);

      for (final draft in drafts) {
        if (draft.createdAt.isAfter(startOfWeek) &&
            draft.createdAt.isBefore(endOfWeek)) {
          final index = draft.createdAt.weekday - 1;
          if (index >= 0 && index < 7) {
            activity[index]++;
          }
        }
      }

      return activity;
    },
    loading: () => List<int>.filled(7, 0),
    error: (_, __) => List<int>.filled(7, 0),
  );
});
