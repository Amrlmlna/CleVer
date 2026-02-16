import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to track if there are unsaved changes in the Profile Page
/// Defaults to false.
final profileUnsavedChangesProvider = StateProvider<bool>((ref) => false);
