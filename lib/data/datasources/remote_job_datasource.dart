import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../models/job_posting_model.dart';

class RemoteJobDataSource {
  final http.Client _httpClient;

  RemoteJobDataSource({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static String get _jobBaseUrl => '${ApiConfig.baseUrl}/job';

  Future<Map<String, dynamic>> extractFromText(String text) async {
    final response = await _httpClient.post(
      Uri.parse('$_jobBaseUrl/extract'),
      headers: await ApiConfig.getAuthHeaders(),
      body: jsonEncode({'text': text}),
    );

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
    try {
      final response = await _httpClient.get(
        Uri.parse(_jobBaseUrl), 
        headers: await ApiConfig.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => JobPostingModel.fromJson(json)).toList();
      } else {
        throw http.ClientException(
          'Failed to load jobs: ${response.statusCode}',
          response.request?.url,
        );
      }
    } catch (e) {
      return [];
    }
  }
}
