import '../../domain/entities/user_profile.dart';
import '../datasources/remote_cv_datasource.dart';
import '../utils/data_error_mapper.dart';
import '../../core/utils/deduplication_utils.dart';

class CVImportRepository {
  final RemoteCVDataSource remoteDataSource;

  CVImportRepository({required this.remoteDataSource});

  Future<UserProfile> parseCV(String cvText) async {
    try {
      final data = await remoteDataSource.parseCV(cvText);

      if (data.containsKey('experience') && data['experience'] is List) {
        for (var e in data['experience']) {
          if (e is Map<String, dynamic>) {
            e['fingerprint'] = DeduplicationUtils.generateFingerprint(
              titleOrDegree: e['jobTitle'] ?? '',
              companyOrSchool: e['companyName'] ?? '',
              startDate: e['startDate'] ?? '',
            );
          }
        }
      }

      if (data.containsKey('education') && data['education'] is List) {
        for (var e in data['education']) {
          if (e is Map<String, dynamic>) {
            e['fingerprint'] = DeduplicationUtils.generateFingerprint(
              titleOrDegree: e['degree'] ?? '',
              companyOrSchool: e['schoolName'] ?? '',
              startDate: e['startDate'] ?? '',
            );
          }
        }
      }

      if (data.containsKey('certifications') && data['certifications'] is List) {
        for (var c in data['certifications']) {
          if (c is Map<String, dynamic>) {
            final rawDate = c['date'];
            final dateStr = rawDate is String ? rawDate : rawDate?.toString() ?? '';
            
            c['fingerprint'] = DeduplicationUtils.generateFingerprint(
              titleOrDegree: c['name'] ?? '',
              companyOrSchool: c['issuer'] ?? '',
              startDate: dateStr,
            );
          }
        }
      }

      return UserProfile.fromJson(data);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
