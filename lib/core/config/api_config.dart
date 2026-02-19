import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiConfig {
  static String get baseUrl {
    final url = dotenv.env['BASE_URL'];
    if (url == null || url.isEmpty) {
      // Fallback for development if .env is missing (though it shouldn't be)
      // Use 10.0.2.2 for Android Emulator
      return 'http://10.0.2.2:8080/api'; 
    }
    return url;
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
