import '../../domain/entities/curated_account.dart';
import '../../domain/entities/job_posting.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasources/remote_job_datasource.dart';
import '../datasources/static_curated_accounts.dart';

class JobRepositoryImpl implements JobRepository {
  final RemoteJobDataSource remoteDataSource;

  JobRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<CuratedAccount>> getCuratedAccounts() async {
    // Returning static list directly. Could be moved to a Remote source later.
    return StaticCuratedAccounts.accounts;
  }

  @override
  Future<List<JobPosting>> getJobPostings() async {
    return await remoteDataSource.getJobPostings();
  }
}
