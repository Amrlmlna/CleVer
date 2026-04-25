import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../../domain/entities/completed_cv.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../providers/completed_cv_sync_provider.dart';
import '../../../core/services/storage_service.dart';
import 'package:pdfx/pdfx.dart';

const _storageKey = 'completed_cvs';

class CompletedCVNotifier extends AsyncNotifier<List<CompletedCV>> {
  @override
  Future<List<CompletedCV>> build() async {
    final cvs = await _loadFromStorage();

    // Trigger migration check in the background
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

      // If local CV is missing a remote URL, upload it to "re-link" it to the cloud
      if (cv.remotePdfUrl == null) {
        final file = File(cv.pdfPath);
        if (await file.exists()) {
          debugPrint("[Migration] Uploading local CV ${cv.id} to cloud...");
          final newRemoteUrl = await storageService.uploadCompletedCV(file);
          if (newRemoteUrl != null) {
            updatedList[i] = cv.copyWith(remotePdfUrl: newRemoteUrl);
            await syncManager.syncCVNow(updatedList[i]);
            hasChanges = true;
          }
        }
      } else {
        // If it HAS a remote URL but isn't in Firestore metadata yet, sync it
        // (This handles cases where upload succeeded but Firestore write failed)
        await syncManager.syncCVNow(cv);
      }
    }

    if (hasChanges) {
      await _saveToStorage(updatedList);
      state = AsyncData(updatedList);
    }
  }

  Future<void> mergeRemoteCVs(List<CompletedCV> remoteCVs) async {
    final localCVs = state.value ?? [];
    final updatedList = List<CompletedCV>.from(localCVs);
    bool hasChanges = false;

    for (final remote in remoteCVs) {
      final existsIndex = updatedList.indexWhere((l) => l.id == remote.id);
      if (existsIndex == -1) {
        // New CV from cloud
        updatedList.add(remote);
        hasChanges = true;
      } else {
        // Update local with remote URL if missing
        if (updatedList[existsIndex].remotePdfUrl == null &&
            remote.remotePdfUrl != null) {
          updatedList[existsIndex] = updatedList[existsIndex].copyWith(
            remotePdfUrl: remote.remotePdfUrl,
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

    // Immediate cloud sync
    await ref.read(completedCVSyncProvider).syncCVNow(cv);
  }

  Future<void> deleteCompletedCV(String id) async {
    final current = state.value ?? [];
    final cv = current.firstWhere((c) => c.id == id);

    // Delete local files
    final pdfFile = File(cv.pdfPath);
    if (await pdfFile.exists()) await pdfFile.delete();
    if (cv.thumbnailPath != null) {
      final thumbFile = File(cv.thumbnailPath!);
      if (await thumbFile.exists()) await thumbFile.delete();
    }

    // Delete from Firestore
    await ref.read(completedCVSyncProvider).deleteCV(id);

    final updated = current.where((c) => c.id != id).toList();
    await _saveToStorage(updated);
    state = AsyncData(updated);
  }

  Future<void> downloadCVFile(CompletedCV cv) async {
    if (cv.remotePdfUrl == null) return;

    state = const AsyncLoading();
    try {
      final response = await http.get(Uri.parse(cv.remotePdfUrl!));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        final storageDir = await getStorageDir();
        final fileName = cv.pdfPath.split('/').last;
        final localFile = File("${storageDir.path}/$fileName");
        await localFile.writeAsBytes(bytes);

        // Regenerate thumbnail locally
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
          debugPrint("Failed to regenerate thumbnail: $e");
        }

        final updatedCV = cv.copyWith(
          pdfPath: localFile.path,
          thumbnailPath: thumbnailPath,
        );

        final current = await _loadFromStorage();
        final updatedList = current
            .map((item) => item.id == cv.id ? updatedCV : item)
            .toList();

        await _saveToStorage(updatedList);
        state = AsyncData(updatedList);
      } else {
        throw Exception("Failed to download PDF: ${response.statusCode}");
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
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
      CompletedCVNotifier.new,
    );
