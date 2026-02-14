import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user_profile.dart';

class CVImportRepository {
  static const String baseUrl = 'https://cvmaster-chi.vercel.app';
  
  /// Parse CV text and return UserProfile
  Future<UserProfile> parseCV(String cvText) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/cv/parse-cv'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'cvText': cvText}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserProfile.fromJson(data);
      } else {
        throw Exception('Failed to parse CV: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error parsing CV: $e');
    }
  }
}
