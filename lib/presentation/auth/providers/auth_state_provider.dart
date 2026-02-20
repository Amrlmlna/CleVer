import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../data/datasources/remote_user_datasource.dart';
import '../../../domain/entities/app_user.dart';

final remoteUserDataSourceProvider = Provider<RemoteUserDataSource>((ref) {
  return RemoteUserDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(remoteUserDataSourceProvider);
  return FirebaseAuthRepository(remoteDataSource: dataSource);
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value != null;
});

final userDisplayNameProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.displayName;
});

final userPhotoUrlProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.photoUrl;
});

final isPremiumProvider = StateProvider<bool>((ref) => false);
