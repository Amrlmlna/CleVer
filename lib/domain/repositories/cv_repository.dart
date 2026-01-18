import '../entities/cv_data.dart';
import '../entities/job_input.dart';
import '../entities/user_profile.dart';

abstract class CVRepository {
  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
  });

  Future<String> rewriteContent(String originalText);
}
