import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/template_repository.dart';
import '../../../data/repositories/template_repository_impl.dart';

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepositoryImpl();
});
