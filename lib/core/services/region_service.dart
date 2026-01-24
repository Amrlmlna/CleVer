import 'dart:convert';
import 'package:http/http.dart' as http;

class RegionService {
  static const String _baseUrl = 'https://www.emsifa.com/api-wilayah-indonesia/api';

  // Cache to avoid repeated calls
  List<dynamic>? _cachedProvinces;
  final Map<String, List<dynamic>> _cachedRegencies = {};

  Future<List<dynamic>> getProvinces() async {
    if (_cachedProvinces != null) return _cachedProvinces!;

    try {
      final response = await http.get(Uri.parse('$_baseUrl/provinces.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cachedProvinces = data;
        return data;
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      // debugPrint('Error fetching provinces: $e');
      return [];
    }
  }

  Future<List<dynamic>> getRegencies(String provinceId) async {
    if (_cachedRegencies.containsKey(provinceId)) {
      return _cachedRegencies[provinceId]!;
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl/regencies/$provinceId.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cachedRegencies[provinceId] = data;
        return data;
      } else {
        throw Exception('Failed to load regencies');
      }
    } catch (e) {
      // debugPrint('Error fetching regencies: $e');
      return [];
    }
  }
}
