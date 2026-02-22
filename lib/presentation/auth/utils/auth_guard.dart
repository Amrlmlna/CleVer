import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../auth/widgets/auth_wall_bottom_sheet.dart';

class AuthGuard {
  static bool check(
    BuildContext context, {
    String? featureTitle,
    String? featureDescription,
    VoidCallback? onAuthenticated,
  }) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      AuthWallBottomSheet.show(
        context,
        featureTitle: featureTitle,
        featureDescription: featureDescription,
        onAuthenticated: onAuthenticated,
      );
      return false;
    }
    return true;
  }

  static VoidCallback protected(
    BuildContext context,
    VoidCallback action, {
    String? featureTitle,
    String? featureDescription,
  }) {
    return () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        action();
      } else {
        AuthWallBottomSheet.show(
          context,
          featureTitle: featureTitle,
          featureDescription: featureDescription,
          onAuthenticated: action,
        );
      }
    };
  }
}
