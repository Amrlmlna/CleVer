import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../domain/entities/cv_data.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';

class RemoteAIService {
  // Use 10.0.2.2 for Android Emulator, 192.168.1.5 for local network
  // Production (Vercel)
  static const String baseUrl = 'https://cvmaster-chi.vercel.app/api/cv';
  
  // Dev (Emulator): 'http://10.0.2.2:3000/api/cv'
  // Dev (Physical Device): 'http://192.168.x.x:3000/api/cv'

  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
    required String language,
  }) async {
    final url = Uri.parse('$baseUrl/generate');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'profile': profile.toJson(),
          'jobInput': jobInput.toJson(),
          'language': language,
        }),
      );

      if (response.statusCode == 200) {
        print('DEBUG: Raw AI Response: ${response.body}');
        
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is! Map) {
          throw Exception('AI response is not a JSON object');
        }
        
        // Use dynamic to avoid Map<String, dynamic> casting issues
        final data = decoded;
        
        // 1. Safe Summary
        final String summary = data['generatedSummary']?.toString() ?? 'Summary not available.';
        
        // 2. Safe Skills
        final List<String> tailoredSkills = [];
        final dynamic rawSkills = data['tailoredSkills'] ?? data['skills'];
        if (rawSkills is List) {
          tailoredSkills.addAll(rawSkills.map((e) => e.toString()));
        }
        
        // 3. Safe Experience Analysis
        final refinedMap = <String, String>{};
        final dynamic rawAnalysis = data['analyzedExperience'];
        if (rawAnalysis is List) {
          for (var item in rawAnalysis) {
            if (item is Map) {
              final key = item['originalTitle']?.toString().toLowerCase();
              final val = item['refinedDescription']?.toString();
              if (key != null && val != null) {
                refinedMap[key] = val;
              }
            }
          }
        }
        
        // Merge refined descriptions into existing experience list
        final refinedExperience = profile.experience.map((exp) {
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

        return CVData(
          id: const Uuid().v4(),
          userProfile: profile.copyWith(
            skills: tailoredSkills, 
            experience: refinedExperience, // Use refined list
            education: profile.education,
          ),
          generatedSummary: summary,
          tailoredSkills: tailoredSkills,
          styleId: styleId,
          createdAt: DateTime.now(),
          jobTitle: jobInput.jobTitle,
          language: language,
        );
      } else {
        throw Exception('Failed to generate CV: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  Future<String> rewriteContent(String originalText, String language) async {
    final url = Uri.parse('$baseUrl/rewrite');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'originalText': originalText,
          'language': language,
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
}
