import '../../domain/entities/user_profile.dart';
import '../datasources/remote_cv_datasource.dart';
import '../utils/data_error_mapper.dart';

class CVImportRepository {
  final RemoteCVDataSource remoteDataSource;

  CVImportRepository({required this.remoteDataSource});
  
  Future<UserProfile> parseCV(String cvText) async {
    try {
      final data = await remoteDataSource.parseCV(cvText);
      return UserProfile.fromJson(data);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
