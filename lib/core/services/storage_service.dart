import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class StorageService {
  static String get _uploadUrl => '${ApiConfig.baseUrl}/user/photo';

  Future<String?> uploadProfilePhoto(File file, String userId) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      final headers = await ApiConfig.getAuthHeaders();
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      final extension = file.path.split('.').last.toLowerCase();
      final mimeSubType =
          (extension == 'png' || extension == 'webp' || extension == 'gif')
          ? extension
          : 'jpeg';

      final multipartFile = await http.MultipartFile.fromPath(
        'photo',
        file.path,
        filename: 'profile.$extension',
        contentType: MediaType('image', mimeSubType),
      );

      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final downloadUrl = data['photoUrl'];
        debugPrint('Profile photo uploaded via backend: $downloadUrl');
        return downloadUrl;
      } else {
        debugPrint(
          'Failed to upload photo via backend: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading profile photo via backend: $e');
      return null;
    }
  }

  static String get _cvUploadUrl => '${ApiConfig.baseUrl}/cv/upload';

  Future<Map<String, String?>?> uploadCompletedCV(File file) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_cvUploadUrl));

      final headers = await ApiConfig.getAuthHeaders();
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      final multipartFile = await http.MultipartFile.fromPath(
        'pdf',
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType('application', 'pdf'),
      );

      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'pdfUrl': data['pdfUrl'] as String?,
          'remotePath': data['remotePath'] as String?,
        };
      } else {
        debugPrint(
          'Failed to upload CV: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading CV: $e');
      return null;
    }
  }

  Future<void> deleteProfilePhoto(String userId) async {
    try {
      final headers = await ApiConfig.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/user/photo'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        debugPrint('[StorageService] Profile photo deleted successfully');
      } else {
        debugPrint(
          '[StorageService] Failed to delete photo: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('[StorageService] Error deleting profile photo: $e');
    }
  }

  /// Deletes a completed CV's PDF file from the GCS bucket via the backend.
  /// Returns true if the backend confirmed deletion (or the file was already gone).
  Future<bool> deleteCompletedCVFromStorage(String remotePath) async {
    try {
      final headers = await ApiConfig.getAuthHeaders();
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/cv/delete',
      ).replace(queryParameters: {'path': remotePath});

      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        debugPrint('[StorageService] GCS file deleted: $remotePath');
        return true;
      } else {
        debugPrint(
          '[StorageService] GCS delete failed: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('[StorageService] Error deleting GCS file: $e');
      return false;
    }
  }
}
