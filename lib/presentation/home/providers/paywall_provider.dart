import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks if a paywall (credit purchase) should be shown when the user returns
/// to the app after an external action (like viewing a PDF).
final pendingPaywallProvider = StateProvider<bool>((ref) => false);
