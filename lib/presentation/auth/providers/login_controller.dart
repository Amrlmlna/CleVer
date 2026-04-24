import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/providers/profile_sync_provider.dart';
import './auth_state_provider.dart';

class LoginController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final user = await authRepo.signInWithEmailAndPassword(
        email.trim(),
        password,
      );

      if (user != null) {
        try {
          await ref.read(profileSyncProvider).initialCloudFetch(user.uid);
        } catch (e) {
          print("Sync failed on login: $e");
        }
      }
    });

    return !state.hasError;
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final user = await authRepo.signInWithGoogle();

      if (user != null) {
        try {
          await ref.read(profileSyncProvider).initialCloudFetch(user.uid);
        } catch (e) {
          print("Sync failed on Google login: $e");
        }
      }
    });

    return !state.hasError;
  }
}

final loginControllerProvider =
    AutoDisposeAsyncNotifierProvider<LoginController, void>(() {
      return LoginController();
    });
