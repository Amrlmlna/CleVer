import 'dart:async';
import 'dart:convert';
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

    print("[DraftSyncManager] Initializing...");

    final initialUser = _ref.read(authStateProvider).value;
    if (initialUser != null) {
      print(
        "[DraftSyncManager] User already logged in at startup: ${initialUser.uid}. Triggering fetch...",
      );
      initialCloudFetch(initialUser.uid);
    }

    _ref.listen(authStateProvider, (prev, next) {
      final user = next.value;
      if (user != null && (prev == null || prev.value == null)) {
        print(
          "[DraftSyncManager] Login detected: ${user.uid}. Triggering initial cloud fetch...",
        );
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
        print("[DraftSyncManager] Error loading sync cache: $e");
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
      print("[DraftSyncManager] Fetching drafts from Firestore for $uid...");
      final cloudDrafts = await _firestoreRepo.getDrafts(uid);
      final localDrafts = await _ref.read(draftRepositoryProvider).getDrafts();

      if (cloudDrafts.isEmpty && localDrafts.isEmpty) {
        print("[DraftSyncManager] No drafts found anywhere.");
        return;
      }

      print(
        "[DraftSyncManager] merging: ${cloudDrafts.length} from cloud, ${localDrafts.length} from local.",
      );

      final Map<String, CVData> mergedMap = {};
      for (var d in localDrafts) {
        mergedMap[d.id] = d;
      }

      for (var cloudDraft in cloudDrafts) {
        final existing = mergedMap[cloudDraft.id];
        if (existing != null) {
          if (cloudDraft.createdAt.isAfter(existing.createdAt)) {
            print(
              "[DraftSyncManager] Conflict on ${cloudDraft.id}: Cloud is newer. Overwriting local.",
            );
            mergedMap[cloudDraft.id] = cloudDraft;
          } else {
            print(
              "[DraftSyncManager] Conflict on ${cloudDraft.id}: Local is newer or same. Keeping local.",
            );
          }
        } else {
          print("[DraftSyncManager] New draft from cloud: ${cloudDraft.id}");
          mergedMap[cloudDraft.id] = cloudDraft;
        }
      }

      final mergedList = mergedMap.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print(
        "[DraftSyncManager] Final merged list contains ${mergedList.length} drafts. Persisting...",
      );
      await _ref.read(draftsProvider.notifier).saveAllDrafts(mergedList);

      await _updateLastSyncedCache(mergedList);

      print("[DraftSyncManager] Initial merge SUCCESSFUL.");
    } catch (e) {
      print("[DraftSyncManager] Initial fetch/merge error: $e");
    }
  }

  Future<void> deleteDraftNow(String draftId) async {
    final user = _ref.read(authStateProvider).value;
    if (user == null) return;

    try {
      print(
        "[DraftSyncManager] Deleting draft $draftId immediately from cloud...",
      );
      await _firestoreRepo.deleteDraft(user.uid, draftId);

      // Update cache immediately to prevent heartbeat from re-syncing
      if (_lastSyncedDrafts != null) {
        _lastSyncedDrafts!.removeWhere((d) => d.id == draftId);
        await _updateLastSyncedCache(_lastSyncedDrafts!);
      }
    } catch (e) {
      print("[DraftSyncManager] Immediate delete error: $e");
    }
  }

  Future<void> deleteFolderNow(List<String> draftIds) async {
    final user = _ref.read(authStateProvider).value;
    if (user == null) return;

    try {
      print(
        "[DraftSyncManager] Deleting ${draftIds.length} drafts immediately from cloud...",
      );
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
      print("[DraftSyncManager] Immediate folder delete error: $e");
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
      print(
        "[DraftSyncManager] Local changes detected! Syncing with Cloud for ${user.uid}...",
      );
      try {
        if (_lastSyncedDrafts != null) {
          final currentIds = currentDrafts.map((d) => d.id).toSet();
          for (final oldDraft in _lastSyncedDrafts!) {
            if (!currentIds.contains(oldDraft.id)) {
              print(
                "[DraftSyncManager] Deleting draft ${oldDraft.id} from cloud...",
              );
              await _firestoreRepo.deleteDraft(user.uid, oldDraft.id);
            }
          }
        }

        for (final draft in currentDrafts) {
          await _firestoreRepo.saveDraft(user.uid, draft);
        }

        await _updateLastSyncedCache(currentDrafts);
        print("[DraftSyncManager] Heartbeat sync SUCCESSFUL.");
      } catch (e) {
        print("[DraftSyncManager] Heartbeat sync error: $e");
      }
    }
  }

  void dispose() {
    _heartbeatTimer?.cancel();
  }
}
