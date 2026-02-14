import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/cv_data.dart';
import '../../domain/repositories/draft_repository.dart';

class DraftRepositoryImpl implements DraftRepository {
  static const String _storageKey = 'cv_drafts';

  @override
  Future<void> saveDraft(CVData cv) async {
    final drafts = await getDrafts();
    
    // Check if draft with same ID exists and update it, or add new
    final index = drafts.indexWhere((d) => d.id == cv.id);
    if (index != -1) {
      drafts[index] = cv;
    } else {
      drafts.insert(0, cv); // Add to beginning
    }

    await _persistDrafts(drafts);
  }

  @override
  Future<void> saveAllDrafts(List<CVData> drafts) async {
    await _persistDrafts(drafts);
  }

  @override
  Future<List<CVData>> getDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    
    if (data == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => CVData.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> deleteDraft(String id) async {
    final drafts = await getDrafts();
    drafts.removeWhere((d) => d.id == id);
    await _persistDrafts(drafts);
  }

  Future<void> _persistDrafts(List<CVData> drafts) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(drafts.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encodedData);
  }
}
