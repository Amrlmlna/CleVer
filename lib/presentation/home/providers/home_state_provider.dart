import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../templates/providers/template_provider.dart';

final isPremiumUserProvider = Provider<bool>((ref) {
  final templatesAsync = ref.watch(templatesProvider);
  
  return templatesAsync.maybeWhen(
    data: (templates) {
      if (templates.isEmpty) return false;
      return templates.any((t) => t.userCredits > 0);
    },
    orElse: () => false,
  );
});
