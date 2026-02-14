import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/entities/cv_data.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/tailored_cv_result.dart';
import 'remote_ai_service.dart';

class MockAIService implements RemoteAIService {
  
  @override
  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
  }) async {
    // Simulate Network Delay
    await Future.delayed(const Duration(seconds: 2));

    // Dummy AI-Enhanced Description
    const String summary = "Profesional yang berdedikasi dengan pengalaman mendalam dalam industri. Terbukti mampu meningkatkan efisiensi operasional dan memimpin tim lintas fungsi menuju kesuksesan proyek. Ahli dalam memecahkan masalah kompleks dengan solusi inovatif.";

    // Dummy Tailored Skills
    final List<String> tailoredSkills = [
      'Strategic Planning',
      'Team Leadership',
      'Data Analysis',
      'Project Management',
      if (jobInput.jobTitle.toLowerCase().contains('dev')) 'Software Development',
      if (jobInput.jobTitle.toLowerCase().contains('design')) 'UI/UX Design',
      'Communication'
    ];

    // Dummy Enhanced Experience
    // Dummy Enhanced Experience
    final refinedExperience = profile.experience.map<Experience>((e) {
      return e.copyWith(
        description: "Meningkatkan produktivitas tim sebesar 20% melalui implementasi metodologi Agile. Memimpin pengembangan fitur utama yang berdampak pada 10.000+ pengguna aktif bulanan.",
      );
    }).toList();

    return CVData(
      id: const Uuid().v4(),
      userProfile: profile.copyWith(
        skills: tailoredSkills,
        experience: refinedExperience,
      ),
      summary: summary,
      styleId: styleId,
      createdAt: DateTime.now(),
      jobTitle: jobInput.jobTitle,
    );
  }

  @override
  Future<TailoredCVResult> tailorProfile({
    required UserProfile masterProfile,
    required JobInput jobInput,
  }) async {
    // Simulate Network Delay
    await Future.delayed(const Duration(seconds: 1));

    // Just return master profile but maybe add a skill or two relevant to job
    final newSkills = List<String>.from(masterProfile.skills);
    if (!newSkills.contains("Adaptability")) newSkills.add("Adaptability");

    final dummySummary = "This is a mock summary generated during tailoring for ${jobInput.jobTitle}.";

    final tailoredProfile = masterProfile.copyWith(skills: newSkills);

    return TailoredCVResult(
      profile: tailoredProfile,
      summary: dummySummary,
    );
  }

  @override
  Future<String> rewriteContent(String originalText) async {
    // Simulate Network Delay
    await Future.delayed(const Duration(milliseconds: 800));

    return "[AI Rewritten] $originalText (Versi Lebih Profesional)";
  }
}
