import '../../domain/entities/cv_data.dart';
import '../datasources/firestore_datasource.dart';
import '../utils/data_error_mapper.dart';

class FirestoreDraftRepository {
  final FirestoreDataSource dataSource;

  FirestoreDraftRepository({required this.dataSource});

  Future<void> saveDraft(String uid, CVData draft) async {
    try {
      await dataSource.setData(
        'users/$uid/drafts/${draft.id}',
        draft.toJson(),
      );
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<void> deleteDraft(String uid, String draftId) async {
    try {
      await dataSource.deleteData('users/$uid/drafts/$draftId');
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<List<CVData>> getDrafts(String uid) async {
    try {
      final snapshot = await dataSource.collection('users/$uid/drafts')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => CVData.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
