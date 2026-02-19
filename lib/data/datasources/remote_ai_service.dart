import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../domain/entities/cv_data.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/tailored_cv_result.dart'; // Import at top
import '../../core/config/api_config.dart';

class RemoteAIService {
  static String get baseUrl => '${ApiConfig.baseUrl}/cv';

  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
  }) async {
    final url = Uri.parse('$baseUrl/generate');

    try {
      final response = await http.post(
        url,
        headers: await ApiConfig.getAuthHeaders(),
        body: jsonEncode({
          'profile': profile.toJson(),
          'jobInput': jobInput.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        return _parseCVResponse(response.body, profile, jobInput, styleId);
      } else {
        throw Exception('Failed to generate CV: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  CVData _parseCVResponse(
    String responseBody, 
    UserProfile profile, 
    JobInput jobInput, 
    String styleId
  ) {
    print('DEBUG: Raw AI Response: $responseBody');
    
    final dynamic decoded = jsonDecode(responseBody);
    if (decoded is! Map) {
      throw Exception('AI response is not a JSON object');
    }
    
    final data = decoded;
    
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
        education: profile.education,
      ),
      summary: summary,
      styleId: styleId,
      createdAt: DateTime.now(),
      jobTitle: jobInput.jobTitle,
    );
  }

  List<Experience> _refineExperience(List<Experience> originalExperience, dynamic rawAnalysis) {
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
        return Experience(
          jobTitle: exp.jobTitle,
          companyName: exp.companyName,
          startDate: exp.startDate,
          endDate: exp.endDate,
          description: refinedDesc, // Use AI refined description
        );
      }
      return exp;
    }).toList();
  }

  Future<String> rewriteContent(String originalText) async {
    final url = Uri.parse('$baseUrl/rewrite');

    try {
      final response = await http.post(
        url,
        headers: await ApiConfig.getAuthHeaders(),
        body: jsonEncode({
          'originalText': originalText,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['rewrittenText'] as String;
      } else {
        throw Exception('Failed to rewrite content: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }


  Future<TailoredCVResult> tailorProfile({
    required UserProfile masterProfile,
    required JobInput jobInput,
  }) async {
    final url = Uri.parse('$baseUrl/tailor'); 

    try {
      final response = await http.post(
        url,
        headers: await ApiConfig.getAuthHeaders(),
        body: jsonEncode({
          'masterProfile': masterProfile.toJson(),
          'jobInput': jobInput.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Backend returns: { tailoredProfile: {...}, summary: "..." }
        final profileJson = data['tailoredProfile'] as Map<String, dynamic>;
        final summary = data['summary'] as String;

        return TailoredCVResult(
          profile: UserProfile.fromJson(profileJson),
          summary: summary,
        );
      } else {
        throw Exception('Failed to tailor profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network Error (Tailor): $e');
    }
  }
}
