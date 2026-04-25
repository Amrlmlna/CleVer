import '../entities/cv_data.dart';
import '../entities/job_input.dart';
import '../entities/user_profile.dart';
import '../entities/tailored_cv_result.dart';
import '../entities/tailoring_options.dart';
import '../entities/subject.dart';

import '../entities/pdf_generation_result.dart';

abstract class CVRepository {
  Future<String> rewriteContent(String originalText, {String? locale});

  Future<TailoredCVResult> tailorProfile({
    required UserProfile masterProfile,
    required JobInput jobInput,
    String? locale,
    TailoringOptions? options,
  });

  Future<PDFGenerationResult> downloadPDF({
    required CVData cvData,
    required String templateId,
    String? locale,
    bool usePhoto = false,
    String? photoUrl,
  });

  Future<({List<Subject> subjects, String? gpa})> parseStudyCard(String text);
}
