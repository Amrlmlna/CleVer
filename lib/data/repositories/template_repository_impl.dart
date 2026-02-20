import '../../domain/entities/cv_template.dart';
import '../../domain/repositories/template_repository.dart';
import '../../core/config/api_config.dart';
import '../datasources/remote_template_datasource.dart';
import '../utils/data_error_mapper.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final RemoteTemplateDataSource remoteDataSource;

  TemplateRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CVTemplate>> getAllTemplates() async {
    try {
      final jsonList = await remoteDataSource.getAllTemplates();
      return jsonList.map<CVTemplate>((json) {
        final template = CVTemplate.fromJson(json);
        if (template.thumbnailUrl.startsWith('/')) {
          final host = ApiConfig.baseUrl.replaceAll('/api', '');
          return template.copyWith(thumbnailUrl: '$host${template.thumbnailUrl}');
        }
        return template;
      }).toList();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<CVTemplate?> getTemplateById(String id) async {
    try {
      final templates = await getAllTemplates();
      return templates.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}

