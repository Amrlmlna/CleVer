import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../../domain/entities/completed_cv.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../providers/completed_cv_sync_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/config/api_config.dart';
import 'package:pdfx/pdfx.dart';

const _storageKey = 'completed_cvs';

class CompletedCVNotifier extends AsyncNotifier<List<CompletedCV>> {
  @override
  Future<List<CompletedCV>> build() async {
    final cvs = await _loadFromStorage();

    _migrationCheck();

    return cvs;
  }

  Future<List<CompletedCV>> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      return CompletedCV.listFromJsonString(jsonString);
    } catch (e) {
      debugPrint("Error parsing local CVs: $e");
      return [];
    }
  }

  Future<void> _saveToStorage(List<CompletedCV> cvs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, CompletedCV.listToJsonString(cvs));
  }

  Future<void> _migrationCheck() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final current = state.value ?? [];
    bool hasChanges = false;
    final updatedList = List<CompletedCV>.from(current);

    final storageService = StorageService();
    final syncManager = ref.read(completedCVSyncProvider);

    for (int i = 0; i < updatedList.length; i++) {
      final cv = updatedList[i];

      if (cv.remotePath == null && cv.remotePdfUrl != null) {
        final recoveredPath = _recoverPathFromUrl(cv.remotePdfUrl!);
        if (recoveredPath != null) {
          debugPrint(
            "[Migration] Recovered path for CV ${cv.id}: $recoveredPath",
          );
          updatedList[i] = updatedList[i].copyWith(remotePath: recoveredPath);
          hasChanges = true;
          await syncManager.syncCVNow(updatedList[i]);
        }
      }

      if (updatedList[i].remotePdfUrl == null ||
          updatedList[i].remotePath == null) {
        final file = File(updatedList[i].pdfPath);
        if (await file.exists()) {
          debugPrint(
            "[Migration] Uploading local CV ${updatedList[i].id} to cloud...",
          );
          final uploadResult = await storageService.uploadCompletedCV(file);
          if (uploadResult != null) {
            updatedList[i] = updatedList[i].copyWith(
              remotePdfUrl: uploadResult['pdfUrl'],
              remotePath: uploadResult['remotePath'],
            );
            await syncManager.syncCVNow(updatedList[i]);
            hasChanges = true;
          }
        }
      } else {
        await syncManager.syncCVNow(updatedList[i]);
      }
    }

    if (hasChanges) {
      await _saveToStorage(updatedList);
      state = AsyncData(updatedList);
    }
  }

  String? _recoverPathFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host == 'storage.googleapis.com') {
        final segments = uri.pathSegments;
        if (segments.length >= 2) {
          return segments.skip(1).join('/');
        }
      } else if (uri.host.contains('.storage.googleapis.com')) {
        return uri.pathSegments.join('/');
      }
    } catch (e) {
      debugPrint("Path recovery failed: $e");
    }
    return null;
  }

  Future<void> mergeRemoteCVs(List<CompletedCV> remoteCVs) async {
    final localCVs = state.value ?? [];
    final updatedList = List<CompletedCV>.from(localCVs);
    bool hasChanges = false;

    for (final remote in remoteCVs) {
      final existsIndex = updatedList.indexWhere((l) => l.id == remote.id);
      if (existsIndex == -1) {
        updatedList.add(remote);
        hasChanges = true;
      } else {
        final local = updatedList[existsIndex];
        if ((local.remotePdfUrl == null && remote.remotePdfUrl != null) ||
            (local.remotePath == null && remote.remotePath != null)) {
          updatedList[existsIndex] = local.copyWith(
            remotePdfUrl: remote.remotePdfUrl,
            remotePath: remote.remotePath,
          );
          hasChanges = true;
        }
      }
    }

    if (hasChanges) {
      updatedList.sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
      await _saveToStorage(updatedList);
      state = AsyncData(updatedList);
    }
  }

  Future<void> addCompletedCV(CompletedCV cv) async {
    final current = state.value ?? [];
    final updated = [cv, ...current];
    await _saveToStorage(updated);
    state = AsyncData(updated);

    await ref.read(completedCVSyncProvider).syncCVNow(cv);
  }

  Future<void> deleteCompletedCV(String id) async {
    final current = state.value ?? [];
    final cv = current.firstWhere((c) => c.id == id);

    final pdfFile = File(cv.pdfPath);
    if (await pdfFile.exists()) await pdfFile.delete();
    if (cv.thumbnailPath != null) {
      final thumbFile = File(cv.thumbnailPath!);
      if (await thumbFile.exists()) await thumbFile.delete();
    }

    await ref.read(completedCVSyncProvider).deleteCV(id);

    final updated = current.where((c) => c.id != id).toList();
    await _saveToStorage(updated);
    state = AsyncData(updated);
  }

  Future<void> downloadCVFile(CompletedCV cv, WidgetRef ref) async {
    final downloadingSet = ref.read(downloadingCVsProvider.notifier);
    downloadingSet.update((state) => {...state, cv.id});

    debugPrint("[Download] Starting download for CV: ${cv.id}");
    debugPrint("[Download] Remote Path: ${cv.remotePath}");
    debugPrint("[Download] Original URL: ${cv.remotePdfUrl}");

    try {
      String? downloadUrl = cv.remotePdfUrl;
      String? effectiveRemotePath = cv.remotePath;

      if (effectiveRemotePath == null || effectiveRemotePath.isEmpty) {
        if (cv.remotePdfUrl != null) {
          effectiveRemotePath = _recoverPathFromUrl(cv.remotePdfUrl!);
          if (effectiveRemotePath != null) {
            debugPrint(
              "[Download] Proactively recovered path: $effectiveRemotePath",
            );

            final updatedCV = cv.copyWith(remotePath: effectiveRemotePath);
            final current = state.value ?? [];
            final updatedList = current
                .map((item) => item.id == cv.id ? updatedCV : item)
                .toList();
            await _saveToStorage(updatedList);
            state = AsyncData(updatedList);

            await ref.read(completedCVSyncProvider).syncCVNow(updatedCV);
          }
        }
      }

      if (effectiveRemotePath != null && effectiveRemotePath.isNotEmpty) {
        try {
          final authHeaders = await ApiConfig.getAuthHeaders();
          final refreshUri = Uri.parse(
            '${ApiConfig.baseUrl}/cv/url',
          ).replace(queryParameters: {'path': effectiveRemotePath});

          debugPrint("[Download] Refreshing URL via: $refreshUri");

          final refreshResponse = await http.get(
            refreshUri,
            headers: authHeaders,
          );

          if (refreshResponse.statusCode == 200) {
            final data = jsonDecode(refreshResponse.body);
            downloadUrl = data['pdfUrl'];
            debugPrint("[Download] URL refreshed successfully.");
          } else {
            debugPrint(
              "[Download] URL refresh FAILED: ${refreshResponse.statusCode} - ${refreshResponse.body}",
            );
          }
        } catch (e) {
          debugPrint("[Download] Exception during URL refresh: $e");
        }
      }

      if (downloadUrl == null || downloadUrl.isEmpty) {
        throw Exception("No download URL available. Please sync first.");
      }

      debugPrint("[Download] Fetching file from: $downloadUrl");
      final response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final storageDir = await getStorageDir();
        final fileName = cv.pdfPath.split('/').last;
        final localFile = File("${storageDir.path}/$fileName");

        await localFile.writeAsBytes(bytes);
        debugPrint("[Download] File saved to: ${localFile.path}");

        // 3. Regenerate thumbnail locally
        String? thumbnailPath;
        try {
          final thumbDir = await getThumbnailDir();
          final thumbFile = File('${thumbDir.path}/${cv.id}_thumb.png');

          final document = await PdfDocument.openData(bytes);
          final page = await document.getPage(1);
          final pageImage = await page.render(
            width: page.width * 0.5,
            height: page.height * 0.5,
            format: PdfPageImageFormat.png,
            backgroundColor: '#FFFFFF',
          );

          if (pageImage != null) {
            await thumbFile.writeAsBytes(pageImage.bytes);
            thumbnailPath = thumbFile.path;
          }
          await page.close();
          await document.close();
        } catch (e) {
          debugPrint("[Download] Thumbnail regeneration failed: $e");
        }

        final updatedCV = cv.copyWith(
          pdfPath: localFile.path,
          thumbnailPath: thumbnailPath,
        );

        final current = state.value ?? [];
        final updatedList = current
            .map((item) => item.id == cv.id ? updatedCV : item)
            .toList();

        await _saveToStorage(updatedList);
        state = AsyncData(updatedList);
        debugPrint("[Download] State updated successfully.");
      } else {
        debugPrint(
          "[Download] GCS Download FAILED: ${response.statusCode} - ${response.body}",
        );
        throw Exception(
          "GCS Error ${response.statusCode}: Link expired or invalid.",
        );
      }
    } catch (e) {
      debugPrint("[Download] Critical failure: $e");
      rethrow;
    } finally {
      downloadingSet.update(
        (state) => state.where((id) => id != cv.id).toSet(),
      );
    }
  }

  static Future<Directory> getStorageDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cvDir = Directory('${appDir.path}/completed_cvs');
    if (!await cvDir.exists()) {
      await cvDir.create(recursive: true);
    }
    return cvDir;
  }

  static Future<Directory> getThumbnailDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final thumbDir = Directory('${appDir.path}/cv_thumbnails');
    if (!await thumbDir.exists()) {
      await thumbDir.create(recursive: true);
    }
    return thumbDir;
  }
}

final completedCVProvider =
    AsyncNotifierProvider<CompletedCVNotifier, List<CompletedCV>>(
      () => CompletedCVNotifier(),
    );

final downloadingCVsProvider = StateProvider<Set<String>>((ref) => {});
