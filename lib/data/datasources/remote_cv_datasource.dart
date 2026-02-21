import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';

class RemoteCVDataSource {
  final http.Client _httpClient;

  RemoteCVDataSource({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  static String get _cvBaseUrl => '${ApiConfig.baseUrl}/cv';

  Future<Map<String, dynamic>> generateCV({
    required Map<String, dynamic> profileJson,
    required Map<String, dynamic> jobInputJson,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('$_cvBaseUrl/generate'),
      headers: await ApiConfig.getAuthHeaders(),
      body: jsonEncode({
        'profile': profileJson,
        'jobInput': jobInputJson,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw http.ClientException('Failed to generate CV: ${response.statusCode}', response.request?.url);
    }
  }

  Future<Map<String, dynamic>> tailorProfile({
    required Map<String, dynamic> masterProfileJson,
    required Map<String, dynamic> jobInputJson,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('$_cvBaseUrl/tailor'),
      headers: await ApiConfig.getAuthHeaders(),
      body: jsonEncode({
        'masterProfile': masterProfileJson,
        'jobInput': jobInputJson,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw http.ClientException('Failed to tailor profile: ${response.statusCode}', response.request?.url);
    }
  }

  Future<String> rewriteContent(String originalText) async {
    final response = await _httpClient.post(
      Uri.parse('$_cvBaseUrl/rewrite'),
      headers: await ApiConfig.getAuthHeaders(),
      body: jsonEncode({
        'originalText': originalText,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['rewrittenText'] as String;
    } else {
      throw http.ClientException('Failed to rewrite content: ${response.statusCode}', response.request?.url);
    }
  }

  Future<Map<String, dynamic>> parseCV(String cvText) async {
    final response = await _httpClient.post(
      Uri.parse('$_cvBaseUrl/parse'),
      headers: await ApiConfig.getAuthHeaders(),
      body: jsonEncode({'cvText': cvText}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw http.ClientException('Failed to parse CV: ${response.statusCode}', response.request?.url);
    }
  }

  Future<List<int>> downloadPDF({
    required Map<String, dynamic> cvDataJson,
    required String templateId,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('$_cvBaseUrl/generate'),
      headers: await ApiConfig.getAuthHeaders(),
      body: jsonEncode({
        'cvData': cvDataJson,
        'templateId': templateId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String? pdfUrl = data['pdfUrl'];
      
      if (pdfUrl == null || pdfUrl.isEmpty) {
        throw http.ClientException('Generated PDF URL is empty');
      }

      final pdfResponse = await http.get(Uri.parse(pdfUrl));
      if (pdfResponse.statusCode == 200) {
        return pdfResponse.bodyBytes;
      } else {
        throw http.ClientException('Failed to download PDF from GCS: ${pdfResponse.statusCode}');
      }
    } else {
      throw http.ClientException('Failed to generate PDF: ${response.statusCode}', response.request?.url);
    }
  }
}
