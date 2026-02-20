import '../../domain/entities/cv_data.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/tailored_cv_result.dart';
import '../../domain/repositories/cv_repository.dart';
import '../datasources/remote_cv_datasource.dart';
import '../utils/cv_data_parser.dart';
import '../utils/data_error_mapper.dart';

class CVRepositoryImpl implements CVRepository {
  final RemoteCVDataSource remoteDataSource;

  CVRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
  }) async {
    try {
      final responseData = await remoteDataSource.generateCV(
        profileJson: profile.toJson(),
        jobInputJson: jobInput.toJson(),
      );

      return CVDataParser.parseGenerateResponse(
        data: responseData,
        profile: profile,
        jobInput: jobInput,
        styleId: styleId,
      );
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<String> rewriteContent(String originalText) async {
    try {
      return await remoteDataSource.rewriteContent(originalText);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<TailoredCVResult> tailorProfile({
    required UserProfile masterProfile,
    required JobInput jobInput,
  }) async {
    try {
      final responseData = await remoteDataSource.tailorProfile(
        masterProfileJson: masterProfile.toJson(),
        jobInputJson: jobInput.toJson(),
      );

      final profileJson = responseData['tailoredProfile'] as Map<String, dynamic>;
      final summary = responseData['summary'] as String;

      return TailoredCVResult(
        profile: UserProfile.fromJson(profileJson),
        summary: summary,
      );
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<List<int>> downloadPDF({
    required CVData cvData,
    required String templateId,
  }) async {
    try {
      return await remoteDataSource.downloadPDF(
        cvDataJson: cvData.toJson(),
        templateId: templateId,
      );
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
