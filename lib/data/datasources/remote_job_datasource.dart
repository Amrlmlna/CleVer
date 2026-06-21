import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../models/job_posting_model.dart';
import '../models/curated_account_model.dart';

class RemoteJobDataSource {
  final http.Client _httpClient;

  RemoteJobDataSource({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static String get _jobBaseUrl => '${ApiConfig.baseUrl}/job';

  Future<Map<String, dynamic>> extractFromText(String text) async {
    final response = await _httpClient
        .post(
          Uri.parse('$_jobBaseUrl/extract'),
          headers: await ApiConfig.getAuthHeaders(),
          body: jsonEncode({'text': text}),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw http.ClientException(
        'Failed to extract job posting: ${response.statusCode}',
        response.request?.url,
      );
    }
  }

  Future<List<JobPostingModel>> getJobPostings() async {
    final response = await _httpClient
        .get(Uri.parse(_jobBaseUrl), headers: await ApiConfig.getAuthHeaders())
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => JobPostingModel.fromJson(json)).toList();
    } else {
      throw http.ClientException(
        'Failed to load jobs: ${response.statusCode}',
        response.request?.url,
      );
    }
  }

  Future<List<CuratedAccountModel>> getCuratedAccounts() async {
    final response = await _httpClient
        .get(
          Uri.parse('$_jobBaseUrl/accounts'),
          headers: await ApiConfig.getAuthHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CuratedAccountModel.fromJson(json)).toList();
    } else {
      throw http.ClientException(
        'Failed to load accounts: ${response.statusCode}',
        response.request?.url,
      );
    }
  }
}
