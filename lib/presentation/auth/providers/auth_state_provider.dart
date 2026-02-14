import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import '../../../domain/repositories/auth_repository.dart';

/// Provider for the Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

/// Stream of auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Whether user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value != null;
});

/// User display name (if logged in)
final userDisplayNameProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.displayName;
});

/// User photo URL (if logged in via Google)
final userPhotoUrlProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.photoURL;
});

/// Whether user has premium subscription (Still Mocked)
final isPremiumProvider = StateProvider<bool>((ref) => false);
