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
    required String language,
  }) async {
    // Simulate Network Delay
    await Future.delayed(const Duration(seconds: 2));

    final isIndo = language == 'id';

    // Dummy AI-Enhanced Description
    final String summary = isIndo 
        ? "Profesional ${jobInput.jobTitle} yang berdedikasi dengan pengalaman mendalam dalam industri. Terbukti mampu meningkatkan efisiensi operasional dan memimpin tim lintas fungsi menuju kesuksesan proyek. Ahli dalam memecahkan masalah kompleks dengan solusi inovatif."
        : "Dedicated ${jobInput.jobTitle} professional with extensive industry experience. Proven track record of improving operational efficiency and leading cross-functional teams to project success. Expert in solving complex problems with innovative solutions.";

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
    final refinedExperience = profile.experience.map((e) {
      return e.copyWith(
        description: isIndo
            ? "Meningkatkan produktivitas tim sebesar 20% melalui implementasi metodologi Agile. Memimpin pengembangan fitur utama yang berdampak pada 10.000+ pengguna aktif bulanan."
            : "Increased team productivity by 20% through Agile methodology implementation. Led the development of key features impacting 10,000+ monthly active users.",
      );
    }).toList();

    return CVData(
      id: const Uuid().v4(),
      userProfile: profile.copyWith(
        skills: tailoredSkills,
        experience: refinedExperience,
      ),
      generatedSummary: summary,
      tailoredSkills: tailoredSkills,
      styleId: styleId,
      createdAt: DateTime.now(),
      jobTitle: jobInput.jobTitle,
      language: language,
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
  Future<String> rewriteContent(String originalText, String language) async {
    // Simulate Network Delay
    await Future.delayed(const Duration(milliseconds: 800));

    return language == 'id'
        ? "[AI Rewritten] $originalText (Versi Lebih Profesional)"
        : "[AI Rewritten] $originalText (More Professional Version)";
  }
}
