import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple counter provider used to signal the HomePage to check for
/// pending reviews or tutorials after a successful CV generation.
final reviewCheckProvider = StateProvider<int>((ref) => 0);
