import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../../domain/entities/pdf_generation_result.dart';

class RemoteCVDataSource {
  final http.Client _httpClient;

  RemoteCVDataSource({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static String get _cvBaseUrl => '${ApiConfig.baseUrl}/cv';

  Future<Map<String, dynamic>> tailorProfile({
    required Map<String, dynamic> masterProfileJson,
    required Map<String, dynamic> jobInputJson,
    String? locale,
    Map<String, dynamic>? tailoringOptionsJson,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('$_cvBaseUrl/tailor'),
      headers: await ApiConfig.getAuthHeaders(),
      body: jsonEncode({
        'masterProfile': masterProfileJson,
        'jobInput': jobInputJson,
        if (locale != null) 'locale': locale,
        if (tailoringOptionsJson != null)
          'tailoringOptions': tailoringOptionsJson,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw http.ClientException(
        'Failed to tailor profile: ${response.statusCode}',
        response.request?.url,
      );
    }
  }

  Future<String> rewriteContent(String originalText, {String? locale}) async {
    final response = await _httpClient.post(
      Uri.parse('$_cvBaseUrl/rewrite'),
      headers: await ApiConfig.getAuthHeaders(),
      body: jsonEncode({
        'originalText': originalText,
        if (locale != null) 'locale': locale,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['rewrittenText'] as String;
    } else {
      throw http.ClientException(
        'Failed to rewrite content: ${response.statusCode}',
        response.request?.url,
      );
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
      throw http.ClientException(
        'Failed to parse CV: ${response.statusCode}',
        response.request?.url,
      );
    }
  }

  Future<Map<String, dynamic>> parseStudyCard(String text) async {
    final response = await _httpClient.post(
      Uri.parse('${ApiConfig.baseUrl}/education/parse-study-card'),
      headers: await ApiConfig.getAuthHeaders(),
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw http.ClientException(
        'Failed to parse Study Card: ${response.statusCode}',
        response.request?.url,
      );
    }
  }

  Future<PDFGenerationResult> downloadPDF({
    required Map<String, dynamic> cvDataJson,
    required String templateId,
    String? locale,
    bool usePhoto = false,
    String? photoUrl,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('$_cvBaseUrl/generate'),
      headers: await ApiConfig.getAuthHeaders(),
      body: jsonEncode({
        'cvData': cvDataJson,
        'templateId': templateId,
        if (locale != null) 'locale': locale,
        'usePhoto': usePhoto,
        if (usePhoto && photoUrl != null) 'photoUrl': photoUrl,
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
        final bytes = pdfResponse.bodyBytes;
        final startString = String.fromCharCodes(bytes.take(100));

        if (startString.contains('<?xml') || startString.contains('<Error>')) {
          throw http.ClientException(
            'Received XML error instead of PDF. Check GCS permissions.',
          );
        }

        if (!startString.contains('%PDF')) {
          throw http.ClientException('Downloaded file is not a valid PDF.');
        }

        return PDFGenerationResult(bytes: bytes, pdfUrl: pdfUrl);
      } else {
        throw http.ClientException(
          'Failed to download PDF from GCS: ${pdfResponse.statusCode}',
        );
      }
    } else {
      throw http.ClientException(
        'Failed to generate PDF: ${response.statusCode}',
        response.request?.url,
      );
    }
  }
}
