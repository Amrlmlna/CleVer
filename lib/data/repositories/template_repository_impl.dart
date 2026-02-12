import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/cv_template.dart';
import '../../domain/repositories/template_repository.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  // TODO: Move base URL to configuration/env
  final String baseUrl = 'https://cvmaster-chi.vercel.app/api'; // Production URL

  @override
  Future<List<CVTemplate>> getAllTemplates() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/templates'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => CVTemplate.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load templates');
      }
    } catch (e) {
      // Fallback or rethrow
      print('Error fetching templates: $e');
      return []; 
    }
  }

  @override
  Future<CVTemplate?> getTemplateById(String id) async {
    try {
      // Option A: Fetch all and find (efficient for small lists)
      final templates = await getAllTemplates();
      return templates.firstWhere((t) => t.id == id);
      
      // Option B: Dedicated endpoint (if available)
      // final response = await http.get(Uri.parse('$baseUrl/templates/$id'));
    } catch (e) {
      return null;
    }
  }
}

