import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../data/datasources/remote_user_datasource.dart';
import '../../../domain/entities/app_user.dart';

final remoteUserDataSourceProvider = Provider<RemoteUserDataSource>((ref) {
  return RemoteUserDataSource();
});

/// Provider for the Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(remoteUserDataSourceProvider);
  return FirebaseAuthRepository(remoteDataSource: dataSource);
});

/// Stream of auth state changes
final authStateProvider = StreamProvider<AppUser?>((ref) {
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
  return authState.value?.photoUrl;
});

/// Whether user has premium subscription (Still Mocked)
final isPremiumProvider = StateProvider<bool>((ref) => false);
