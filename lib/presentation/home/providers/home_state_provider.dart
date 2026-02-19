import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../templates/providers/template_provider.dart';

/// Provider that determines if the user has premium status (credits > 0).
/// Adheres to 'Untrusted UI' by deriving state from backend-provided template/usage data.
final isPremiumUserProvider = Provider<bool>((ref) {
  final templatesAsync = ref.watch(templatesProvider);
  
  return templatesAsync.maybeWhen(
    data: (templates) {
      if (templates.isEmpty) return false;
      // If any template says user has credits > 0, they are "premium" for the banner's purposes
      return templates.any((t) => (t.userCredits ?? 0) > 0);
    },
    orElse: () => false,
  );
});
