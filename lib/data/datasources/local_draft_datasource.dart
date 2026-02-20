import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDraftDataSource {
  static const String _storageKey = 'cv_drafts';

  Future<List<dynamic>> getDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data == null) return [];
    return jsonDecode(data);
  }

  Future<void> saveDrafts(List<dynamic> drafts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(drafts));
  }
}
