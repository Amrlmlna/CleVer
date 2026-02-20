import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class IpLocationService {
  static const String _apiUrl = 'http://ip-api.com/json';

  Future<String?> getCountryCode() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl)).timeout(
        const Duration(seconds: 5),
      );

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
      debugPrint('[IpLocationService] Exception: $e');
    }
    return null;
  }
}
