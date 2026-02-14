import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/firestore_draft_repository.dart';
import '../../../domain/entities/cv_data.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../providers/draft_provider.dart';

/// Periodic Sync Manager for CV Drafts
/// 
/// Runs a heartbeat every 30s to check for local changes and push to Cloud.
/// Also handles the initial cloud-to-local sync on login.
final draftSyncProvider = Provider<DraftSyncManager>((ref) {
  final manager = DraftSyncManager(ref);
  return manager;
});

class DraftSyncManager {
  final Ref _ref;
  Timer? _heartbeatTimer;
  List<CVData>? _lastSyncedDrafts;
  static const String _syncKey = 'last_synced_drafts_json';
  
  final FirestoreDraftRepository _firestoreRepo = FirestoreDraftRepository();

  DraftSyncManager(this._ref);

  void init() {
    print("[DraftSyncManager] Initializing...");
    
    // 1. Listen for Auth changes to trigger initial fetch
    _ref.listen(authStateProvider, (prev, next) {
      final user = next.value;
      if (user != null && (prev == null || prev.value == null)) {
        print("[DraftSyncManager] User logged in: ${user.uid}. Triggering initial drafts fetch...");
        initialCloudFetch(user.uid);
      }
    });

    // 2. Start Periodic Heartbeat (every 30s)
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) => _heartbeat());
    
    // Load last synced from local cache
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
    final String encodedData = jsonEncode(drafts.map((e) => e.toJson()).toList());
    await prefs.setString(_syncKey, encodedData);
  }

  /// Initial fetch from Cloud to Local on login/startup
  Future<void> initialCloudFetch(String uid) async {
    try {
      final cloudDrafts = await _firestoreRepo.getDrafts(uid);
      if (cloudDrafts.isNotEmpty) {
        print("[DraftSyncManager] ${cloudDrafts.length} drafts found in cloud. Merging...");
        
        final localDrafts = await _ref.read(draftRepositoryProvider).getDrafts();
        
        // Merge strategy: Union by ID (Cloud wins on collision)
        final Map<String, CVData> mergedMap = {
          for (var d in localDrafts) d.id: d,
          for (var d in cloudDrafts) d.id: d,
        };
        
        final mergedList = mergedMap.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // Save back to local repository
        // Note: DraftRepositoryImpl._persistDrafts is private, so we use notifier if possible 
        // or just update local storage directly from manager (risky but okay for now)
        // Better: Add a bulk save to DraftRepository interface if needed.
        // For now, let's just save them one by one via notifier to trigger UI updates.
        
        for (final draft in mergedList) {
           await _ref.read(draftsProvider.notifier).saveDraft(draft);
        }

        await _updateLastSyncedCache(mergedList);
      } else {
        print("[DraftSyncManager] Cloud drafts are empty for this user.");
      }
    } catch (e) {
      print("[DraftSyncManager] Initial fetch error: $e");
    }
  }

  /// The "Heartbeat" - periodically check for changes
  Future<void> _heartbeat() async {
    final draftsAsync = _ref.read(draftsProvider);
    final user = _ref.read(authStateProvider).value;

    if (user == null) return;
    
    // We only sync if data is actually loaded and ready
    final currentDrafts = draftsAsync.value;
    if (currentDrafts == null) return;

    // Compare with last synced version using Deep Equality
    final Function eq = const DeepCollectionEquality().equals;
    if (!eq(currentDrafts, _lastSyncedDrafts)) {
      print("[DraftSyncManager] Changes detected in drafts! Syncing with Cloud for ${user.uid}...");
      try {
        // 1. Handle Deletions: Find IDs in lastSynced that aren't in current
        if (_lastSyncedDrafts != null) {
          final currentIds = currentDrafts.map((d) => d.id).toSet();
          for (final oldDraft in _lastSyncedDrafts!) {
            if (!currentIds.contains(oldDraft.id)) {
              print("[DraftSyncManager] Deleting draft ${oldDraft.id} from cloud...");
              await _firestoreRepo.deleteDraft(user.uid, oldDraft.id);
            }
          }
        }

        // 2. Handle Saves/Updates: Push everything to cloud (Firestore handles updates via set)
        for (final draft in currentDrafts) {
           await _firestoreRepo.saveDraft(user.uid, draft);
        }

        await _updateLastSyncedCache(currentDrafts);
        print("[DraftSyncManager] Drafts sync SUCCESSFUL.");
      } catch (e) {
        print("[DraftSyncManager] Heartbeat sync error: $e");
      }
    }
  }

  void dispose() {
    _heartbeatTimer?.cancel();
  }
}
