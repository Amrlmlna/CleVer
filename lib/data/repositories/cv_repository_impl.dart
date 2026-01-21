import '../../domain/entities/cv_data.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/cv_repository.dart';
import '../datasources/remote_ai_service.dart';

class CVRepositoryImpl implements CVRepository {
  final RemoteAIService aiService;

  CVRepositoryImpl({required this.aiService});

  @override
  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
    required String language,
  }) {
    return aiService.generateCV(
      profile: profile,
      jobInput: jobInput,
      styleId: styleId,
      language: language,
    );
  }
  @override
  Future<String> rewriteContent(String originalText, String language) {
    return aiService.rewriteContent(originalText, language);
  }
}
