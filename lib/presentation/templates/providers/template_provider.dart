import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/cv_template.dart';
import '../../../domain/repositories/template_repository.dart';
import '../../../data/repositories/template_repository_impl.dart';
import '../../../data/datasources/remote_template_datasource.dart';
import '../../auth/providers/auth_state_provider.dart';

final remoteTemplateDataSourceProvider = Provider<RemoteTemplateDataSource>((ref) {
  return RemoteTemplateDataSource();
});

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  final dataSource = ref.watch(remoteTemplateDataSourceProvider);
  return TemplateRepositoryImpl(remoteDataSource: dataSource);
});

final templatesProvider = FutureProvider<List<CVTemplate>>((ref) async {
  // Watch auth state to ensure templates refresh when user login/logout
  ref.watch(authStateProvider);
  
  final repository = ref.watch(templateRepositoryProvider);
  return repository.getAllTemplates();
});
