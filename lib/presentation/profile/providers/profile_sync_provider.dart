import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/firestore_profile_repository.dart';
import '../../../domain/entities/user_profile.dart';
import '../../auth/providers/auth_state_provider.dart';
import 'profile_provider.dart';
import '../../../core/providers/firebase_providers.dart';

final firestoreProfileRepositoryProvider = Provider<FirestoreProfileRepository>(
  (ref) {
    final dataSource = ref.watch(firestoreDataSourceProvider);
    return FirestoreProfileRepository(dataSource: dataSource);
  },
);

final profileSyncProvider = Provider<ProfileSyncManager>((ref) {
  return ProfileSyncManager(ref);
});

class ProfileSyncManager {
  final Ref _ref;
  Timer? _heartbeatTimer;
  UserProfile? _lastSyncedProfile;
  static const String _syncKey = 'last_synced_profile_json';

  late final FirestoreProfileRepository _firestoreRepo;

  ProfileSyncManager(this._ref) {
    _firestoreRepo = _ref.read(firestoreProfileRepositoryProvider);
  }

  void init() {
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
    final json = prefs.getString(_syncKey);
    if (json != null) {
      try {
        _lastSyncedProfile = UserProfile.fromJson(jsonDecode(json));
      } catch (e) {
        debugPrint("[SyncManager] Error loading sync cache: $e");
      }
    }
  }

  Future<void> _updateLastSyncedCache(UserProfile profile) async {
    _lastSyncedProfile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_syncKey, jsonEncode(profile.toJson()));
  }

  Future<void> initialCloudFetch(String uid) async {
    try {
      final cloudProfile = await _firestoreRepo.getProfile(uid);
      if (cloudProfile != null) {
        await _ref
            .read(masterProfileProvider.notifier)
            .mergeProfile(cloudProfile);
        _updateLastSyncedCache(_ref.read(masterProfileProvider)!);
      }
    } catch (e) {
      debugPrint("[SyncManager] Initial fetch error: $e");
    }
  }

  Future<void> _heartbeat() async {
    await syncProfileNow();
  }

  Future<void> syncProfileNow() async {
    final currentProfile = _ref.read(masterProfileProvider);
    final user = _ref.read(authStateProvider).value;

    if (currentProfile == null || user == null) return;

    if (currentProfile != _lastSyncedProfile) {
      try {
        await _firestoreRepo.saveProfile(user.uid, currentProfile);
        await _updateLastSyncedCache(currentProfile);
      } catch (e) {
        debugPrint("[SyncManager] Sync error: $e");
        rethrow;
      }
    }
  }

  void dispose() {
    _heartbeatTimer?.cancel();
  }
}
