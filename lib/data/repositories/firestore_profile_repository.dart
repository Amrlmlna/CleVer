import '../../domain/entities/user_profile.dart';
import '../datasources/firestore_datasource.dart';
import '../utils/data_error_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProfileRepository {
  final FirestoreDataSource dataSource;

  FirestoreProfileRepository({required this.dataSource});

  Future<void> saveProfile(String uid, UserProfile profile) async {
    try {
      await dataSource.collection('users').doc(uid).set(
            profile.toJson(),
            SetOptions(merge: true),
          );
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<UserProfile?> getProfile(String uid) async {
    try {
      final doc = await dataSource.getData('users/$uid');
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromJson(doc.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
