import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/job_input.dart';

class JobExtractionRepository {
  // TODO: Get this from environment or config
  static const String baseUrl = 'https://cvmaster-chi.vercel.app'; // Update this to your backend URL

  /// Extract job posting from raw text using Groq API via backend
  Future<JobInput> extractFromText(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/job/extract-from-text'),
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
