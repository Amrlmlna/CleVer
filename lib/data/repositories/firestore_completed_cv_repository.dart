import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/completed_cv.dart';
import '../datasources/firestore_datasource.dart';
import '../utils/data_error_mapper.dart';

class FirestoreCompletedCVRepository {
  final FirestoreDataSource dataSource;

  FirestoreCompletedCVRepository({required this.dataSource});

  String _getCollectionPath(String uid) => 'users/$uid/completed_cvs';

  Future<void> saveCompletedCV(String uid, CompletedCV cv) async {
    try {
      await dataSource
          .collection(_getCollectionPath(uid))
          .doc(cv.id)
          .set(cv.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<List<CompletedCV>> getCompletedCVs(String uid) async {
    try {
      final snapshot = await dataSource
          .collection(_getCollectionPath(uid))
          .get();
      return snapshot.docs
          .map(
            (doc) => CompletedCV.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<void> deleteCompletedCV(String uid, String cvId) async {
    try {
      await dataSource.collection(_getCollectionPath(uid)).doc(cvId).delete();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
