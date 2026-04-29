import 'package:flutter/material.dart';
import '../../auth/utils/auth_guard.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

class FloatingActionCircle extends StatelessWidget {
  const FloatingActionCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: AuthGuard.protected(
        context,
        () {
          context.push('/create/job-input');
        },
        featureTitle: AppLocalizations.of(context)!.authWallCreateCV,
        featureDescription: AppLocalizations.of(context)!.authWallCreateCVDesc,
      ),
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
