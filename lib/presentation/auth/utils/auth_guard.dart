import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthGuard {
  static bool check(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If not logged in, redirect to login
      context.push('/login');
      return false;
    }
    return true;
  }

  /// Wraps a callback with an auth check
  static VoidCallback protected(BuildContext context, VoidCallback action) {
    return () {
      if (check(context)) {
        action();
      }
    };
  }
}
