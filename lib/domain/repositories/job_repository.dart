import '../entities/curated_account.dart';
import '../entities/job_posting.dart';

abstract class JobRepository {
  Future<List<CuratedAccount>> getCuratedAccounts();
  Future<List<JobPosting>> getJobPostings();
}
