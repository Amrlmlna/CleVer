import '../../domain/entities/cv_data.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/cv_repository.dart';
import '../datasources/mock_ai_service.dart';

class CVRepositoryImpl implements CVRepository {
  final MockAIService mockAIService;

  CVRepositoryImpl({required this.mockAIService});

  @override
  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
  }) {
    return mockAIService.generateCV(
      profile: profile,
      jobInput: jobInput,
      styleId: styleId,
    );
  }
}
