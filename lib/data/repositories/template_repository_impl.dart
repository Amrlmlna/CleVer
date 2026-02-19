import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/cv_template.dart';
import '../../domain/repositories/template_repository.dart';
import '../../core/config/api_config.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final String baseUrl = ApiConfig.baseUrl; 

  @override
  Future<List<CVTemplate>> getAllTemplates() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/templates'),
        headers: await ApiConfig.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map<CVTemplate>((json) {
          final template = CVTemplate.fromJson(json);
          if (template.thumbnailUrl.startsWith('/')) {
            final host = ApiConfig.baseUrl.replaceAll('/api', '');
            return template.copyWith(thumbnailUrl: '$host${template.thumbnailUrl}');
          }
          return template;
        }).toList();
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

