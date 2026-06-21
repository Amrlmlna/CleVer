import '../../domain/entities/curated_account.dart';
import '../../domain/entities/job_posting.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasources/remote_job_datasource.dart';
import '../utils/data_error_mapper.dart';

class JobRepositoryImpl implements JobRepository {
  final RemoteJobDataSource remoteDataSource;

  JobRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CuratedAccount>> getCuratedAccounts() async {
    try {
      return await remoteDataSource.getCuratedAccounts();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<List<JobPosting>> getJobPostings() async {
    try {
      return await remoteDataSource.getJobPostings();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
