import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import 'remote_cv_datasource.dart';

/// Stage 0 (docs/2026-10-31-encryption-architecture.md §3): the CV library —
/// drafts, completed CVs, profile, FCM token — is served by the backend API
/// instead of direct Firestore writes, so server-side encryption can cover it.
/// Endpoints mirror the old Firestore paths and semantics exactly.
class RemoteLibraryDataSource {
  final http.Client _httpClient;

  RemoteLibraryDataSource({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static String get _baseUrl => ApiConfig.baseUrl;

  Future<Map<String, dynamic>> getProfile() => _getJson('/user/profile');

  Future<void> updateProfile(Map<String, dynamic> profileJson) =>
      _sendJson('PUT', '/user/profile', body: profileJson);

  Future<void> updateFcmToken({
    required String token,
    required String platform,
  }) => _sendJson('PUT', '/user/fcm-token', body: {
    'fcmToken': token,
    'platform': platform,
  });

  Future<List<Map<String, dynamic>>> listDrafts() async {
    final json = await _getJson('/cv/drafts');
    return _asMaps(json['drafts']);
  }

  Future<void> saveDraft(String draftId, Map<String, dynamic> draftJson) =>
      _sendJson('PUT', '/cv/drafts/$draftId', body: draftJson);

  Future<void> deleteDraft(String draftId) =>
      _sendJson('DELETE', '/cv/drafts/$draftId');

  Future<List<Map<String, dynamic>>> listCompleted() async {
    final json = await _getJson('/cv/completed');
    return _asMaps(json['completedCvs']);
  }

  /// Used by the CV-upload flow (uploaded PDFs have no /cv/generate record —
  /// the client creates the library entry itself, as before).
  Future<void> saveCompleted(String cvId, Map<String, dynamic> recordJson) =>
      _sendJson('PUT', '/cv/completed/$cvId', body: recordJson);

  Future<void> deleteCompleted(String cvId) =>
      _sendJson('DELETE', '/cv/completed/$cvId');

  Future<Map<String, dynamic>> _getJson(String path) async {
    final response = await _httpClient
        .get(Uri.parse('$_baseUrl$path'), headers: await ApiConfig.getAuthHeaders())
        .timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, responseBody: response.body);
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> _sendJson(String method, String path, {Map<String, dynamic>? body}) async {
    final request = http.Request(method, Uri.parse('$_baseUrl$path'))
      ..headers.addAll(await ApiConfig.getAuthHeaders());
    if (body != null) request.body = jsonEncode(body);

    final response = await _httpClient
        .send(request)
        .timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) {
      final streamed = await http.Response.fromStream(response);
      throw ApiException(response.statusCode, responseBody: streamed.body);
    }
  }

  List<Map<String, dynamic>> _asMaps(dynamic list) =>
      (list as List? ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();
}
