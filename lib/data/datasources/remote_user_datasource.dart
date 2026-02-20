import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';

class RemoteUserDataSource {
  final http.Client _httpClient;

  RemoteUserDataSource({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  static String get _baseUrl => ApiConfig.baseUrl;

  Future<void> deleteAccount() async {
    final response = await _httpClient.delete(
      Uri.parse('$_baseUrl/user/account'),
      headers: await ApiConfig.getAuthHeaders(),
    );

    if (response.statusCode != 200) {
      throw http.ClientException('Failed to delete account: ${response.statusCode}', response.request?.url);
    }
  }
}
