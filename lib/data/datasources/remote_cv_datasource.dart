import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../../domain/entities/pdf_generation_result.dart';

class ApiException implements Exception {
  final int statusCode;
  final String? responseBody;

  ApiException(this.statusCode, {this.responseBody});

  String? get errorCode {
    if (responseBody == null) return null;
    try {
      final body = jsonDecode(responseBody!);
      return body['code'] as String?;
    } catch (_) {
      return null;
    }
  }

  String get errorMessage {
    if (responseBody == null) return 'Request failed ($statusCode)';
    try {
      final body = jsonDecode(responseBody!);
      return body['error'] as String? ?? 'Request failed ($statusCode)';
    } catch (_) {
      return 'Request failed ($statusCode)';
    }
  }
}

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
    final response = await _httpClient
        .post(
          Uri.parse('$_cvBaseUrl/tailor'),
          headers: await ApiConfig.getAuthHeaders(),
          body: jsonEncode({
            'masterProfile': masterProfileJson,
            'jobInput': jobInputJson,
            if (locale != null) 'locale': locale,
            if (tailoringOptionsJson != null)
              'tailoringOptions': tailoringOptionsJson,
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, responseBody: response.body);
    }
  }

  Future<String> rewriteContent(
    String originalText, {
    String? locale,
    String? instruction,
  }) async {
    final response = await _httpClient
        .post(
          Uri.parse('$_cvBaseUrl/rewrite'),
          headers: await ApiConfig.getAuthHeaders(),
          body: jsonEncode({
            'originalText': originalText,
            if (locale != null) 'locale': locale,
            if (instruction != null) 'instruction': instruction,
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['rewrittenText'] as String;
    } else {
      throw ApiException(response.statusCode, responseBody: response.body);
    }
  }

  Future<Map<String, dynamic>> parseCV(String cvText) async {
    final response = await _httpClient
        .post(
          Uri.parse('$_cvBaseUrl/parse'),
          headers: await ApiConfig.getAuthHeaders(),
          body: jsonEncode({'cvText': cvText}),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, responseBody: response.body);
    }
  }

  Future<Map<String, dynamic>> parseStudyCard(String text) async {
    final response = await _httpClient
        .post(
          Uri.parse('${ApiConfig.baseUrl}/education/parse-study-card'),
          headers: await ApiConfig.getAuthHeaders(),
          body: jsonEncode({'text': text}),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, responseBody: response.body);
    }
  }

  Future<Map<String, dynamic>> parseEntity({
    required String text,
    required String entityType,
  }) async {
    final response = await _httpClient
        .post(
          Uri.parse('$_cvBaseUrl/parse-entity'),
          headers: await ApiConfig.getAuthHeaders(),
          body: jsonEncode({'text': text, 'type': entityType}),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, responseBody: response.body);
    }
  }

  Future<PDFGenerationResult> downloadPDF({
    required Map<String, dynamic> cvDataJson,
    required String templateId,
    String? locale,
    bool usePhoto = false,
    String? photoUrl,
  }) async {
    final response = await _httpClient
        .post(
          Uri.parse('$_cvBaseUrl/generate'),
          headers: await ApiConfig.getAuthHeaders(),
          body: jsonEncode({
            'cvData': cvDataJson,
            'templateId': templateId,
            if (locale != null) 'locale': locale,
            'usePhoto': usePhoto,
            if (usePhoto && photoUrl != null) 'photoUrl': photoUrl,
          }),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String? pdfUrl = data['pdfUrl'];
      String? remotePath = data['remotePath'];

      if (pdfUrl == null || pdfUrl.isEmpty) {
        throw http.ClientException('Generated PDF URL is empty');
      }

      final pdfResponse = await http
          .get(Uri.parse(pdfUrl))
          .timeout(const Duration(seconds: 60));
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

        remotePath ??= _recoverPathFromUrl(pdfUrl);

        return PDFGenerationResult(
          bytes: bytes,
          pdfUrl: pdfUrl,
          remotePath: remotePath,
        );
      } else {
        throw http.ClientException(
          'Failed to download PDF from GCS: ${pdfResponse.statusCode}',
        );
      }
    } else {
      throw ApiException(response.statusCode, responseBody: response.body);
    }
  }

  String? _recoverPathFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host == 'storage.googleapis.com') {
        final segments = uri.pathSegments;
        if (segments.length >= 2) {
          return segments.skip(1).join('/');
        }
      } else if (uri.host.contains('.storage.googleapis.com')) {
        return uri.pathSegments.join('/');
      }
    } catch (e) {
      // Ignore recovery failures
    }
    return null;
  }
}
