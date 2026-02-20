import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';

class RemoteTemplateDataSource {
  final http.Client _httpClient;

  RemoteTemplateDataSource({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  static String get _baseUrl => ApiConfig.baseUrl;

  Future<List<dynamic>> getAllTemplates() async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/templates'),
      headers: await ApiConfig.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw http.ClientException('Failed to load templates: ${response.statusCode}', response.request?.url);
    }
  }
}
