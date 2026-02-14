import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/firestore_profile_repository.dart';
import '../../../domain/entities/user_profile.dart';
import '../../auth/providers/auth_state_provider.dart';
import 'profile_provider.dart';

/// Periodic Sync Manager for Profile Data
/// 
/// Runs a heartbeat every 30s to check for local changes and push to Cloud.
/// Also handles the initial cloud-to-local sync on login.
final profileSyncProvider = Provider<ProfileSyncManager>((ref) {
  final manager = ProfileSyncManager(ref);
  // No auto-start here, we'll initialize in main or a top-level widget
  return manager;
});

class ProfileSyncManager {
  final Ref _ref;
  Timer? _heartbeatTimer;
  UserProfile? _lastSyncedProfile;
  static const String _syncKey = 'last_synced_profile_json';
  
  final FirestoreProfileRepository _firestoreRepo = FirestoreProfileRepository();

  ProfileSyncManager(this._ref);

  void init() {
    print("[SyncManager] Initializing...");
    
    // 1. Listen for Auth changes to trigger initial fetch
    _ref.listen(authStateProvider, (prev, next) {
      final user = next.value;
      if (user != null && (prev == null || prev.value == null)) {
        print("[SyncManager] User logged in: ${user.uid}. Triggering initial cloud fetch...");
        initialCloudFetch(user.uid);
      }
    });

    // 2. Start Periodic Heartbeat (every 30s)
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) => _heartbeat());
    
    // Load last synced from local cache to avoid redundant pushes
    _loadLastSyncedCache();
  }

  Future<void> _loadLastSyncedCache() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_syncKey);
    if (json != null) {
      try {
        _lastSyncedProfile = UserProfile.fromJson(jsonDecode(json));
      } catch (e) {
        print("[SyncManager] Error loading sync cache: $e");
      }
    }
  }

  Future<void> _updateLastSyncedCache(UserProfile profile) async {
    _lastSyncedProfile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_syncKey, jsonEncode(profile.toJson()));
  }

  /// Initial fetch from Cloud to Local on login/startup
  Future<void> initialCloudFetch(String uid) async {
    try {
      final cloudProfile = await _firestoreRepo.getProfile(uid);
      if (cloudProfile != null) {
        print("[SyncManager] Cloud data found. Merging into local...");
        await _ref.read(masterProfileProvider.notifier).mergeProfile(cloudProfile);
        _updateLastSyncedCache(_ref.read(masterProfileProvider)!);
      } else {
        print("[SyncManager] Cloud is empty for this user.");
      }
    } catch (e) {
      print("[SyncManager] Initial fetch error: $e");
    }
  }

  /// The "Heartbeat" - periodically check for changes
  Future<void> _heartbeat() async {
    final currentProfile = _ref.read(masterProfileProvider);
    final user = _ref.read(authStateProvider).value;

    if (currentProfile == null || user == null) return;

    // Compare with last synced version
    if (currentProfile != _lastSyncedProfile) {
      print("[SyncManager] Changes detected! Pushing to Cloud for ${user.uid}...");
      try {
        await _firestoreRepo.saveProfile(user.uid, currentProfile);
        await _updateLastSyncedCache(currentProfile);
        print("[SyncManager] Cloud sync SUCCESSFUL.");
      } catch (e) {
        print("[SyncManager] Heartbeat sync error: $e");
      }
    } else {
      // print("[SyncManager] No changes since last sync.");
    }
  }

  void dispose() {
    _heartbeatTimer?.cancel();
  }
}
