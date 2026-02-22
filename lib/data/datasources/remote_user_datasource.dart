import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';

class RemoteUserDataSource {
  final http.Client _httpClient;

  RemoteUserDataSource({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  static String get _baseUrl => ApiConfig.baseUrl;

  Future<void> deleteAccount() async {
    // TODO: Implement fresh account deletion logic
  }
}
