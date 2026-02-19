import '../../domain/entities/job_input.dart';
import '../datasources/remote_job_datasource.dart';
import '../utils/data_error_mapper.dart';

class JobExtractionRepository {
  final RemoteJobDataSource remoteDataSource;

  JobExtractionRepository({required this.remoteDataSource});

  Future<JobInput> extractFromText(String text) async {
    try {
      final data = await remoteDataSource.extractFromText(text);
      return JobInput(
        jobTitle: data['jobTitle'] ?? '',
        company: data['company'],
        jobDescription: data['jobDescription'] ?? data['description'] ?? '',
      );
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
