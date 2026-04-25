import '../../domain/entities/cv_data.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/tailored_cv_result.dart';
import '../../domain/entities/tailor_analysis.dart';
import '../../domain/repositories/cv_repository.dart';
import '../datasources/remote_cv_datasource.dart';

import '../utils/data_error_mapper.dart';
import '../../domain/entities/tailoring_options.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/pdf_generation_result.dart';

class CVRepositoryImpl implements CVRepository {
  final RemoteCVDataSource remoteDataSource;

  CVRepositoryImpl({required this.remoteDataSource});

  @override
  Future<({List<Subject> subjects, String? gpa})> parseStudyCard(
    String text,
  ) async {
    try {
      final responseData = await remoteDataSource.parseStudyCard(text);
      final subjectsJson = responseData['subjects'] as List<dynamic>? ?? [];
      final gpa = responseData['gpa'] as String?;

      final subjects = subjectsJson
          .map((s) => Subject.fromJson(s as Map<String, dynamic>))
          .toList();

      return (subjects: subjects, gpa: gpa);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<String> rewriteContent(String originalText, {String? locale}) async {
    try {
      return await remoteDataSource.rewriteContent(
        originalText,
        locale: locale,
      );
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<TailoredCVResult> tailorProfile({
    required UserProfile masterProfile,
    required JobInput jobInput,
    String? locale,
    TailoringOptions? options,
  }) async {
    try {
      final responseData = await remoteDataSource.tailorProfile(
        masterProfileJson: masterProfile.toJson(),
        jobInputJson: jobInput.toJson(),
        locale: locale,
        tailoringOptionsJson: options?.toJson(),
      );

      final profileJson =
          responseData['tailoredProfile'] as Map<String, dynamic>;
      final summary = responseData['summary'] as String;
      final analysisJson = responseData['analysis'] as Map<String, dynamic>?;

      return TailoredCVResult(
        profile: UserProfile.fromJson(profileJson),
        summary: summary,
        analysis: analysisJson != null
            ? TailorAnalysis.fromJson(analysisJson)
            : null,
      );
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<PDFGenerationResult> downloadPDF({
    required CVData cvData,
    required String templateId,
    String? locale,
    bool usePhoto = false,
    String? photoUrl,
  }) async {
    try {
      return await remoteDataSource.downloadPDF(
        cvDataJson: cvData.toJson(),
        templateId: templateId,
        locale: locale,
        usePhoto: usePhoto,
        photoUrl: photoUrl,
      );
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
