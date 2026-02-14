import '../entities/cv_data.dart';

abstract class DraftRepository {
  Future<void> saveDraft(CVData cv);
  Future<void> saveAllDrafts(List<CVData> drafts);
  Future<List<CVData>> getDrafts();
  Future<void> deleteDraft(String id);
}
