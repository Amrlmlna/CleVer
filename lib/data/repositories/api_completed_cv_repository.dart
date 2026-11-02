import '../datasources/remote_library_datasource.dart';
import '../../domain/entities/completed_cv.dart';
import '../utils/data_error_mapper.dart';

/// Stage 0: the completed-CV library is served by the backend API instead of
/// direct Firestore writes (docs/2026-10-31-encryption-architecture.md §3) so
/// server-side encryption can cover it. Same method signatures as the old
/// Firestore repository — the sync providers swap without changes. Records
/// for generations made through /cv/generate are written server-side; this
/// repository only deletes and re-reads them.
class ApiCompletedCVRepository {
  final RemoteLibraryDataSource dataSource;

  ApiCompletedCVRepository({RemoteLibraryDataSource? dataSource})
    : dataSource = dataSource ?? RemoteLibraryDataSource();

  Future<void> saveCompletedCV(String uid, CompletedCV cv) async {
    try {
      await dataSource.saveCompleted(cv.id, cv.toJson());
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<List<CompletedCV>> getCompletedCVs(String uid) async {
    try {
      final docs = await dataSource.listCompleted();
      return docs.map((doc) => CompletedCV.fromJson(doc)).toList();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<void> deleteCompletedCV(String uid, String cvId) async {
    try {
      await dataSource.deleteCompleted(cvId);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
