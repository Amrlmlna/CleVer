import '../entities/cv_data.dart';
import '../entities/job_input.dart';
import '../entities/user_profile.dart';

abstract class CVRepository {
  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
    required String language,
  });

  Future<String> rewriteContent(String originalText, String language);
}
