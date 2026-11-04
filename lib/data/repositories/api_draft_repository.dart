import '../datasources/remote_library_datasource.dart';
import '../../domain/entities/cv_data.dart';
import '../utils/data_error_mapper.dart';

/// Stage 0: drafts are served by the backend API instead of direct Firestore
/// writes — same paths, shapes and ordering (createdAt desc) as before
/// (docs/2026-10-31-encryption-architecture.md §3).
class ApiDraftRepository {
  final RemoteLibraryDataSource dataSource;

  ApiDraftRepository({RemoteLibraryDataSource? dataSource})
    : dataSource = dataSource ?? RemoteLibraryDataSource();

  Future<void> saveDraft(String uid, CVData draft) async {
    try {
      await dataSource.saveDraft(draft.id, draft.toJson());
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<void> deleteDraft(String uid, String draftId) async {
    try {
      await dataSource.deleteDraft(draftId);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<List<CVData>> getDrafts(String uid) async {
    try {
      final docs = await dataSource.listDrafts();
      return docs.map((doc) => CVData.fromJson(doc)).toList();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
