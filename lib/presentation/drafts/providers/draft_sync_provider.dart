import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/cv_data.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../providers/draft_provider.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../data/repositories/firestore_draft_repository.dart';

final firestoreDraftRepositoryProvider = Provider<FirestoreDraftRepository>((
  ref,
) {
  final dataSource = ref.watch(firestoreDataSourceProvider);
  return FirestoreDraftRepository(dataSource: dataSource);
});

final draftSyncProvider = Provider<DraftSyncManager>((ref) {
  return DraftSyncManager(ref);
});

class DraftSyncManager {
  final Ref _ref;
  Timer? _heartbeatTimer;
  List<CVData>? _lastSyncedDrafts;
  static const String _syncKey = 'last_synced_drafts_json';

  late final FirestoreDraftRepository _firestoreRepo;

  DraftSyncManager(this._ref) {
    _firestoreRepo = _ref.read(firestoreDraftRepositoryProvider);
  }

  bool _isInitialized = false;

  void init() {
    if (_isInitialized) return;
    _isInitialized = true;

    final initialUser = _ref.read(authStateProvider).value;
    if (initialUser != null) {
      initialCloudFetch(initialUser.uid);
    }

    _ref.listen(authStateProvider, (prev, next) {
      final user = next.value;
      if (user != null && (prev == null || prev.value == null)) {
        initialCloudFetch(user.uid);
      }
    });

    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _heartbeat(),
    );

    _loadLastSyncedCache();
  }

  Future<void> _loadLastSyncedCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_syncKey);
    if (jsonString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _lastSyncedDrafts = decoded.map((e) => CVData.fromJson(e)).toList();
      } catch (e) {
        debugPrint("[DraftSyncManager] Error loading sync cache: $e");
      }
    }
  }

  Future<void> _updateLastSyncedCache(List<CVData> drafts) async {
    _lastSyncedDrafts = List.from(drafts);
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      drafts.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_syncKey, encodedData);
  }

  Future<void> initialCloudFetch(String uid) async {
    try {
      final cloudDrafts = await _firestoreRepo.getDrafts(uid);
      final localDrafts = await _ref.read(draftRepositoryProvider).getDrafts();

      if (cloudDrafts.isEmpty && localDrafts.isEmpty) {
        return;
      }

      final Map<String, CVData> mergedMap = {};
      for (var d in localDrafts) {
        mergedMap[d.id] = d;
      }

      for (var cloudDraft in cloudDrafts) {
        final existing = mergedMap[cloudDraft.id];
        if (existing != null) {
          if (cloudDraft.createdAt.isAfter(existing.createdAt)) {
            mergedMap[cloudDraft.id] = cloudDraft;
          }
        } else {
          mergedMap[cloudDraft.id] = cloudDraft;
        }
      }

      final mergedList = mergedMap.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      await _ref.read(draftsProvider.notifier).saveAllDrafts(mergedList);

      await _updateLastSyncedCache(mergedList);
    } catch (e) {
      debugPrint("[DraftSyncManager] Initial fetch/merge error: $e");
    }
  }

  Future<void> deleteDraftNow(String draftId) async {
    final user = _ref.read(authStateProvider).value;
    if (user == null) return;

    try {
      await _firestoreRepo.deleteDraft(user.uid, draftId);

      // Update cache immediately to prevent heartbeat from re-syncing
      if (_lastSyncedDrafts != null) {
        _lastSyncedDrafts!.removeWhere((d) => d.id == draftId);
        await _updateLastSyncedCache(_lastSyncedDrafts!);
      }
    } catch (e) {
      debugPrint("[DraftSyncManager] Immediate delete error: $e");
    }
  }

  Future<void> deleteFolderNow(List<String> draftIds) async {
    final user = _ref.read(authStateProvider).value;
    if (user == null) return;

    try {
      for (final id in draftIds) {
        await _firestoreRepo.deleteDraft(user.uid, id);
      }

      // Update cache
      if (_lastSyncedDrafts != null) {
        final idSet = draftIds.toSet();
        _lastSyncedDrafts!.removeWhere((d) => idSet.contains(d.id));
        await _updateLastSyncedCache(_lastSyncedDrafts!);
      }
    } catch (e) {
      debugPrint("[DraftSyncManager] Immediate folder delete error: $e");
    }
  }

  Future<void> _heartbeat() async {
    final draftsAsync = _ref.read(draftsProvider);
    final user = _ref.read(authStateProvider).value;

    if (user == null) return;

    final currentDrafts = draftsAsync.value;
    if (currentDrafts == null) return;

    final Function eq = const DeepCollectionEquality().equals;
    if (!eq(currentDrafts, _lastSyncedDrafts)) {
      try {
        if (_lastSyncedDrafts != null) {
          final currentIds = currentDrafts.map((d) => d.id).toSet();
          for (final oldDraft in _lastSyncedDrafts!) {
            if (!currentIds.contains(oldDraft.id)) {
              await _firestoreRepo.deleteDraft(user.uid, oldDraft.id);
            }
          }
        }

        for (final draft in currentDrafts) {
          await _firestoreRepo.saveDraft(user.uid, draft);
        }

        await _updateLastSyncedCache(currentDrafts);
      } catch (e) {
        debugPrint("[DraftSyncManager] Heartbeat sync error: $e");
      }
    }
  }

  void dispose() {
    _heartbeatTimer?.cancel();
  }
}
