import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/job_input.dart';
import '../../core/config/api_config.dart';

class JobExtractionRepository {
  static String get baseUrl => ApiConfig.baseUrl;

  /// Extract job posting from raw text using Groq API via backend
  Future<JobInput> extractFromText(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/job/extract'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return JobInput(
          jobTitle: data['jobTitle'] ?? '',
          company: data['company'],
          jobDescription: data['description'] ?? '',
        );
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to extract job posting');
      }
    } catch (e) {
      print('[JobExtractionRepository] Error: $e');
      rethrow;
    }
  }
}
