import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/cv_template.dart';
import '../../../domain/repositories/template_repository.dart';
import '../../../data/repositories/template_repository_impl.dart';

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepositoryImpl();
});

final templatesProvider = FutureProvider<List<CVTemplate>>((ref) async {
  final repository = ref.watch(templateRepositoryProvider);
  return repository.getAllTemplates();
});
