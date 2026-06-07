import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../auth/widgets/auth_wall_bottom_sheet.dart';
import '../../auth/widgets/email_verification_bottom_sheet.dart';

class AuthGuard {
  static bool _isUnverifiedPasswordUser(User user) {
    final isPasswordProvider = user.providerData.any(
      (p) => p.providerId == 'password',
    );
    return isPasswordProvider && !user.emailVerified;
  }

  static bool check(
    BuildContext context, {
    String? featureTitle,
    String? featureDescription,
    VoidCallback? onAuthenticated,
    VoidCallback? onDismiss,
  }) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      AuthWallBottomSheet.show(
        context,
        featureTitle: featureTitle,
        featureDescription: featureDescription,
        onAuthenticated: onAuthenticated,
        onDismiss: onDismiss,
      );
      return false;
    }
    if (_isUnverifiedPasswordUser(user)) {
      EmailVerificationBottomSheet.show(context);
      return false;
    }
    return true;
  }

  static VoidCallback protected(
    BuildContext context,
    VoidCallback action, {
    String? featureTitle,
    String? featureDescription,
    VoidCallback? onDismiss,
  }) {
    return () {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        AuthWallBottomSheet.show(
          context,
          featureTitle: featureTitle,
          featureDescription: featureDescription,
          onAuthenticated: action,
          onDismiss: onDismiss,
        );
      } else if (_isUnverifiedPasswordUser(user)) {
        EmailVerificationBottomSheet.show(context);
      } else {
        action();
      }
    };
  }
}
