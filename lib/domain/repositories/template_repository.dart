import '../entities/cv_template.dart';

abstract class TemplateRepository {
  Future<List<CVTemplate>> getAllTemplates();
  Future<CVTemplate?> getTemplateById(String id);
}
