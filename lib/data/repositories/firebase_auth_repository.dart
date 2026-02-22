import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/app_user.dart';
import '../datasources/remote_user_datasource.dart';
import '../utils/data_error_mapper.dart';
import '../../core/services/payment_service.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final RemoteUserDataSource remoteDataSource;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth, 
    GoogleSignIn? googleSignIn,
    required this.remoteDataSource,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  AppUser? _mapFirebaseUser(fb.User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Stream<AppUser?> get authStateChanges => 
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  AppUser? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  @override
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _mapFirebaseUser(userCredential.user);
      if (user != null) {
        await PaymentService.login(user.uid);
      }
      return user;
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<AppUser?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.sendEmailVerification();
        await userCredential.user!.reload();
        await PaymentService.login(userCredential.user!.uid);
      }
      
      return _mapFirebaseUser(_firebaseAuth.currentUser);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      PaymentService.logout(),
    ]);
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      final GoogleSignInAccount? googleUser = await _googleSignIn.attemptLightweightAuthentication() 
          ?? await _googleSignIn.authenticate();
      
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final authorization = await googleUser.authorizationClient.authorizeScopes(['email']);
      
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = _mapFirebaseUser(userCredential.user);
      if (user != null) {
        await PaymentService.login(user.uid);
      }
      return user;
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<void> deleteAccount() async {
    // TODO: Implement fresh account deletion logic
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<void> reloadUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
