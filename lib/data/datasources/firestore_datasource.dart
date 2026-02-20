import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSource({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference collection(String path) => _firestore.collection(path);
  DocumentReference document(String path) => _firestore.doc(path);

  Future<void> setData(String path, Map<String, dynamic> data) async {
    await _firestore.doc(path).set(data);
  }

  Future<DocumentSnapshot> getData(String path) async {
    return await _firestore.doc(path).get();
  }

  Future<void> deleteData(String path) async {
    await _firestore.doc(path).delete();
  }
  
  WriteBatch batch() => _firestore.batch();
}
