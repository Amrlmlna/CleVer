import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import '../../auth/widgets/email_verification_bottom_sheet.dart';
import '../../../domain/entities/app_user.dart';

class DashboardVerificationHandler {
  static bool _sheetShowing = false;

  static void checkVerification(BuildContext context, AppUser? user) {
    if (user == null) return;

    final firebaseUser = fb.FirebaseAuth.instance.currentUser;
    final isPasswordProvider =
        firebaseUser?.providerData.any((p) => p.providerId == 'password') ??
        false;

    if (isPasswordProvider && !firebaseUser!.emailVerified && !_sheetShowing) {
      _sheetShowing = true;
      EmailVerificationBottomSheet.show(context).then((_) {
        _sheetShowing = false;
      });
    }
  }
}
