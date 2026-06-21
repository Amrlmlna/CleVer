import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class IpLocationService {
  static const String _primaryUrl = 'https://ipapi.co/json/';
  static const String _fallbackUrl = 'http://ip-api.com/json';

  Future<String?> getCountryCode() async {
    try {
      final response = await http
          .get(Uri.parse(_primaryUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final code = data['country_code'] as String?;
        if (code != null) return code.toUpperCase();
      }
    } catch (e) {
      debugPrint(
        '[IpLocationService] Primary HTTPS failed: $e. Trying fallback HTTP...',
      );
    }

    try {
      final response = await http
          .get(Uri.parse(_fallbackUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'fail') {
          debugPrint('[IpLocationService] API failed: ${data['message']}');
          return null;
        }
        return data['countryCode'] as String?;
      } else {
        debugPrint('[IpLocationService] HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('[IpLocationService] Fallback HTTP failed: $e');
    }
    return null;
  }
}
