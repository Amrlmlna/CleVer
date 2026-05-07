import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/firestore_completed_cv_repository.dart';
import '../../../domain/entities/completed_cv.dart';
import '../../auth/providers/auth_state_provider.dart';
import 'completed_cv_provider.dart';
import '../../../core/providers/firebase_providers.dart';

final firestoreCompletedCVRepositoryProvider =
    Provider<FirestoreCompletedCVRepository>((ref) {
      final dataSource = ref.watch(firestoreDataSourceProvider);
      return FirestoreCompletedCVRepository(dataSource: dataSource);
    });

final completedCVSyncProvider = Provider<CompletedCVSyncManager>((ref) {
  return CompletedCVSyncManager(ref);
});

class CompletedCVSyncManager {
  final Ref _ref;
  late final FirestoreCompletedCVRepository _firestoreRepo;

  CompletedCVSyncManager(this._ref) {
    _firestoreRepo = _ref.read(firestoreCompletedCVRepositoryProvider);
  }

  void init() {
    _ref.listen(authStateProvider, (prev, next) {
      final user = next.value;
      if (user != null && (prev == null || prev.value == null)) {
        initialCloudFetch(user.uid);
      }
    });
  }

  Future<void> initialCloudFetch(String uid) async {
    try {
      final cloudCVs = await _firestoreRepo.getCompletedCVs(uid);
      if (cloudCVs.isNotEmpty) {
        await _ref.read(completedCVProvider.notifier).mergeRemoteCVs(cloudCVs);
      }
    } catch (e) {
      debugPrint("[CompletedCVSync] Initial fetch error: $e");
    }
  }

  Future<void> syncCVNow(CompletedCV cv) async {
    final user = _ref.read(authStateProvider).value;
    if (user == null) return;

    try {
      await _firestoreRepo.saveCompletedCV(user.uid, cv);
    } catch (e) {
      debugPrint("[CompletedCVSync] Sync error for CV ${cv.id}: $e");
      rethrow;
    }
  }

  Future<void> deleteCV(String cvId) async {
    final user = _ref.read(authStateProvider).value;
    if (user == null) return;

    try {
      await _firestoreRepo.deleteCompletedCV(user.uid, cvId);
    } catch (e) {
      debugPrint("[CompletedCVSync] Delete error for CV $cvId: $e");
    }
  }
}
