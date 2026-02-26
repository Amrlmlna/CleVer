import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/remote_job_datasource.dart';
import '../../../data/repositories/job_repository_impl.dart';
import '../../../domain/entities/curated_account.dart';
import '../../../domain/entities/job_posting.dart';
import '../../../domain/repositories/job_repository.dart';

// Provides the networking instances
final remoteJobDataSourceProvider = Provider<RemoteJobDataSource>((ref) {
  return RemoteJobDataSource();
});

// Provides the repository
final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final remoteDataSource = ref.watch(remoteJobDataSourceProvider);
  return JobRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Provides the curated Instagram/TikTok accounts
final curatedAccountsProvider = FutureProvider<List<CuratedAccount>>((ref) async {
  final repository = ref.watch(jobRepositoryProvider);
  return await repository.getCuratedAccounts();
});

// Provides the remote API job postings
final apiJobsProvider = FutureProvider<List<JobPosting>>((ref) async {
  final repository = ref.watch(jobRepositoryProvider);
  return await repository.getJobPostings();
});
