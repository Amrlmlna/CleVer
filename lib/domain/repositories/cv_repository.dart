import '../entities/cv_data.dart';
import '../entities/job_input.dart';
import '../entities/user_profile.dart';
import '../entities/tailored_cv_result.dart';

abstract class CVRepository {
  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
  });

  Future<String> rewriteContent(String originalText);
  
  Future<TailoredCVResult> tailorProfile({
    required UserProfile masterProfile,
    required JobInput jobInput,
  });

  Future<List<int>> downloadPDF({
    required CVData cvData,
    required String templateId,
  });
}
