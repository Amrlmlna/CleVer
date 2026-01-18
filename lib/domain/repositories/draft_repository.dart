import '../entities/cv_data.dart';

abstract class DraftRepository {
  Future<void> saveDraft(CVData cv);
  Future<List<CVData>> getDrafts();
  Future<void> deleteDraft(String id);
}
