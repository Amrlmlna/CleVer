import 'package:uuid/uuid.dart';
import '../../domain/entities/cv_data.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/job_input.dart';

class CVDataParser {
  static CVData parseGenerateResponse({
    required Map<String, dynamic> data,
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
  }) {
    final String summary = data['generatedSummary']?.toString() ?? 'Summary not available.';
    
    final List<String> tailoredSkills = [];
    final dynamic rawSkills = data['tailoredSkills'] ?? data['skills'];
    if (rawSkills is List) {
      tailoredSkills.addAll(rawSkills.map((e) => e.toString()));
    }
    
    final refinedExperience = _refineExperience(profile.experience, data['analyzedExperience']);

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

  static List<Experience> _refineExperience(List<Experience> originalExperience, dynamic rawAnalysis) {
    if (rawAnalysis is! List) return originalExperience;

    final refinedMap = <String, String>{};
    for (var item in rawAnalysis) {
      if (item is Map) {
        final key = item['originalTitle']?.toString().toLowerCase();
        final val = item['refinedDescription']?.toString();
        if (key != null && val != null) {
          refinedMap[key] = val;
        }
      }
    }
    
    return originalExperience.map((exp) {
      final refinedDesc = refinedMap[exp.jobTitle.toLowerCase()];
      if (refinedDesc != null) {
        return exp.copyWith(description: refinedDesc);
      }
      return exp;
    }).toList();
  }
}
