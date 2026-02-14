import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cv_data.dart';

class FirestoreDraftRepository {
  final FirebaseFirestore _firestore;

  FirestoreDraftRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveDraft(String uid, CVData draft) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('drafts')
          .doc(draft.id)
          .set(draft.toJson());
    } catch (e) {
      throw Exception('Failed to save draft to cloud: $e');
    }
  }

  Future<void> deleteDraft(String uid, String draftId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('drafts')
          .doc(draftId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete draft from cloud: $e');
    }
  }

  Future<List<CVData>> getDrafts(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('drafts')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => CVData.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch drafts from cloud: $e');
    }
  }
}
