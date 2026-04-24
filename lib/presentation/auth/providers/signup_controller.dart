import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/providers/profile_sync_provider.dart';
import './auth_state_provider.dart';

class SignupController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> signUp(String email, String password, String name) async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);

    String? userId;

    state = await AsyncValue.guard(() async {
      final user = await authRepo.signUpWithEmailAndPassword(
        email.trim(),
        password,
        name.trim(),
      );

      if (user != null) {
        userId = user.uid;
        await authRepo.sendEmailVerification();
      }
    });

    return userId;
  }

  Future<bool> signUpWithGoogle() async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final user = await authRepo.signInWithGoogle();

      if (user != null) {
        try {
          await ref.read(profileSyncProvider).initialCloudFetch(user.uid);
        } catch (e) {
          debugPrint("Sync failed on Google signup: $e");
        }
      }
    });

    return !state.hasError;
  }
}

final signupControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignupController, void>(() {
      return SignupController();
    });
