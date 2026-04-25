import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/firestore_datasource.dart';

final firestoreDataSourceProvider = Provider<FirestoreDataSource>((ref) {
  return FirestoreDataSource();
});
