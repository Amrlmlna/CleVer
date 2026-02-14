import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';

class FirestoreProfileRepository {
  final FirebaseFirestore _firestore;

  FirestoreProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveProfile(String uid, UserProfile profile) async {
    try {
      await _firestore.collection('users').doc(uid).set(
            profile.toJson(),
            SetOptions(merge: true),
          );
    } catch (e) {
      throw Exception('Failed to save profile to cloud: $e');
    }
  }

  Future<UserProfile?> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch profile from cloud: $e');
    }
  }
}
