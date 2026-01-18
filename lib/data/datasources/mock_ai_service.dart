import 'package:uuid/uuid.dart';
import '../../domain/entities/cv_data.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';

class MockAIService {
  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final title = jobInput.jobTitle.toLowerCase();
    
    // Deterministic "AI" Logic
    String summary = '';
    List<String> skills = [];
    
    if (title.contains('manager') || title.contains('lead')) {
      summary = 'Results-oriented ${jobInput.jobTitle} with a proven track record of leading teams and driving strategic initiatives. Expert in optimizing processes and delivering high-impact solutions.';
      skills = ['Leadership', 'Strategic Planning', 'Team Building', 'Project Management', 'Stakeholder Management'];
    } else if (title.contains('engineer') || title.contains('developer')) {
      summary = 'Passionate ${jobInput.jobTitle} with strong technical expertise in building scalable software solutions. Committed to writing clean, maintainable code and solving complex engineering challenges.';
      skills = ['Software Architecture', 'Clean Code', 'System Design', 'Agile Methodologies', 'Problem Solving'];
    } else if (title.contains('designer') || title.contains('creative')) {
      summary = 'Visionary ${jobInput.jobTitle} with a keen eye for aesthetics and user experience. Dedicated to creating intuitive and visually stunning interfaces that delight users.';
      skills = ['UI/UX Design', 'Visual Hierarchy', 'Prototyping', 'User Research', 'Creative Direction'];
    } else {
      // Default / Fallback
      summary = 'Dedicated ${jobInput.jobTitle} professional with a strong work ethic and a desire to contribute to organizational success. Skilled in communication and adaptability.';
      skills = ['Communication', 'Time Management', 'Problem Solving', 'Adaptability', 'Teamwork'];
    }

    // Merge with user's existing skills if any, or prioritize "AI" skills
    final finalSkills = {...skills, ...profile.skills}.toList(); 

    return CVData(
      id: const Uuid().v4(),
      userProfile: profile.copyWith(skills: finalSkills),
      generatedSummary: summary,
      tailoredSkills: finalSkills,
      styleId: styleId,
      createdAt: DateTime.now(),
      jobTitle: jobInput.jobTitle,
    );
  }

  Future<String> rewriteContent(String originalText) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simple mock logic
    if (originalText.startsWith('Passionate')) {
      return originalText.replaceFirst('Passionate', 'Highly skilled and motivated');
    } else if (originalText.startsWith('Dedicated')) {
      return originalText.replaceFirst('Dedicated', 'Results-oriented');
    } else if (originalText.startsWith('Results-oriented')) {
      return originalText.replaceFirst('Results-oriented', 'Strategic and efficient');
    } else {
      return "Professional version: $originalText";
    }
  }
}
