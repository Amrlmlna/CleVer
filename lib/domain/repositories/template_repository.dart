import '../entities/cv_template.dart';

abstract class TemplateRepository {
  List<CVTemplate> getAllTemplates();
  CVTemplate getTemplateById(String id);
}
