import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;
  Future<AppUser?> signInWithEmailAndPassword(String email, String password);
  Future<AppUser?> signUpWithEmailAndPassword(String email, String password, String name);
  Future<void> signOut();
  Future<AppUser?> signInWithGoogle();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> reloadUser();
  Future<void> deleteAccount();
}
