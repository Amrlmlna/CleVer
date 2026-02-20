import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      final token = await user?.getIdToken();
      
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
    } catch (e) {
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
    }
  }
}
