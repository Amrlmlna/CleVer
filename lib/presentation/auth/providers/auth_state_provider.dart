import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder auth state providers
/// TODO: Implement actual authentication logic

/// Whether user is logged in
final isLoggedInProvider = StateProvider<bool>((ref) => false);

/// Whether user has premium subscription
final isPremiumProvider = StateProvider<bool>((ref) => false);

/// User display name (if logged in)
final userDisplayNameProvider = StateProvider<String?>((ref) => null);
