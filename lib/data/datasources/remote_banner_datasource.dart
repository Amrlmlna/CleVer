import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RemoteBannerDataSource {
  final http.Client client;

  RemoteBannerDataSource({required this.client});

  String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080/api';

  Future<List<Map<String, dynamic>>> getActiveBanners() async {
    final response = await client.get(
      Uri.parse('$baseUrl/banners'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load banners');
    }
  }
}
