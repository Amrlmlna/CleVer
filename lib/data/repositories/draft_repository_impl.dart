import '../../domain/entities/cv_data.dart';
import '../../domain/repositories/draft_repository.dart';
import '../datasources/local_draft_datasource.dart';
import '../utils/data_error_mapper.dart';

class DraftRepositoryImpl implements DraftRepository {
  final LocalDraftDataSource localDataSource;

  DraftRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveDraft(CVData cv) async {
    try {
      final drafts = await getDrafts();
      final index = drafts.indexWhere((d) => d.id == cv.id);
      if (index != -1) {
        drafts[index] = cv;
      } else {
        drafts.insert(0, cv);
      }
      await _persistDrafts(drafts);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<void> saveAllDrafts(List<CVData> drafts) async {
    try {
      await _persistDrafts(drafts);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<List<CVData>> getDrafts() async {
    try {
      final data = await localDataSource.getDrafts();
      return data.map((e) => CVData.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> deleteDraft(String id) async {
    try {
      final drafts = await getDrafts();
      drafts.removeWhere((d) => d.id == id);
      await _persistDrafts(drafts);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<void> _persistDrafts(List<CVData> drafts) async {
    final jsonList = drafts.map((e) => e.toJson()).toList();
    await localDataSource.saveDrafts(jsonList);
  }
}
