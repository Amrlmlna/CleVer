import '../entities/cv_data.dart';
import '../entities/job_input.dart';
import '../entities/user_profile.dart';
import '../entities/tailored_cv_result.dart';

abstract class CVRepository {
  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
    String? locale,
  });

  Future<String> rewriteContent(String originalText, {String? locale});
  
  Future<TailoredCVResult> tailorProfile({
    required UserProfile masterProfile,
    required JobInput jobInput,
    String? locale,
  });

  Future<List<int>> downloadPDF({
    required CVData cvData,
    required String templateId,
    String? locale,
  });
}
