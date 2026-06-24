import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/device_id_service.dart';

class ApiConfig {
  static String get baseUrl {
    final url = dotenv.env['BASE_URL'];
    if (url == null || url.isEmpty) {
      return 'http://10.0.2.2:8080/api';
    }
    return url.endsWith('/api') ? url : '$url/api';
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      // Force-refresh to pick up updated claims (e.g. email_verified).
      // The backend auth middleware checks decoded-token claims directly,
      // and without a force-refresh a stale token can persist for ~1 hour.
      final token = await user?.getIdToken(true);
      final deviceId = await DeviceIdService.getDeviceId();

      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        'X-Device-Id': deviceId,
      };
    } catch (e) {
      return {'Content-Type': 'application/json', 'Accept': 'application/json'};
    }
  }
}
