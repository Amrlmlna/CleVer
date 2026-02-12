import '../../domain/entities/cv_data.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/tailored_cv_result.dart'; // Import
import '../../domain/repositories/cv_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../datasources/remote_ai_service.dart';

class CVRepositoryImpl implements CVRepository {
  final RemoteAIService aiService;

  CVRepositoryImpl({required this.aiService});

  @override
  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
    required String language,
  }) {
    return aiService.generateCV(
      profile: profile,
      jobInput: jobInput,
      styleId: styleId,
      language: language,
    );
  }
  @override
  Future<String> rewriteContent(String originalText, String language) {
    return aiService.rewriteContent(originalText, language);
  }

  @override
  Future<TailoredCVResult> tailorProfile({
    required UserProfile masterProfile,
    required JobInput jobInput,
  }) {
    return aiService.tailorProfile(masterProfile: masterProfile, jobInput: jobInput);
  }

  @override
  Future<List<int>> downloadPDF({required CVData cvData, required String templateId}) async {
    // TODO: Use env variable for URL
    final String baseUrl = 'http://10.0.2.2:3000/api'; 
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cv/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cvData': cvData.toJson(),
          'templateId': templateId,
        }),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to generate PDF: ${response.body}');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      rethrow;
    }
  }
}
