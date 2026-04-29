import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/unsaved_changes_dialog.dart';
import '../../profile/providers/profile_provider.dart';
import '../../onboarding/providers/onboarding_auth_capture_provider.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../auth/widgets/auth_wall_bottom_sheet.dart';
import '../../../core/router/app_routes.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class DashboardNavigationHandler {
  static Future<void> onTabTap({
    required BuildContext context,
    required WidgetRef ref,
    required StatefulNavigationShell navigationShell,
    required int index,
  }) async {
    if (index != navigationShell.currentIndex) {
      if (navigationShell.currentIndex == 3) {
        final hasUnsavedChanges = ref
            .read(profileControllerProvider)
            .hasChanges;

        if (hasUnsavedChanges) {
          final shouldLeave = await UnsavedChangesDialog.show(
            context,
            onSave: () async {
              await ref.read(profileControllerProvider.notifier).saveProfile();
            },
            onDiscard: () {
              ref.read(profileControllerProvider.notifier).discardChanges();
            },
          );

          if (shouldLeave != true) return;
        }
      }
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  static void handleOnboardingSuccess({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    // Reset state immediately to avoid duplicate triggers
    ref.read(onboardingAuthCaptureProvider.notifier).state = false;

    final user = ref.read(authStateProvider).value;

    if (user == null) {
      AuthWallBottomSheet.show(
        context,
        featureTitle: AppLocalizations.of(context)!.authWallCreateCV,
        featureDescription: AppLocalizations.of(context)!.authWallCreateCVDesc,
        onAuthenticated: () {
          context.push(AppRoutes.createJobInput);
        },
        onDismiss: () {},
      );
    } else {
      context.push(AppRoutes.createJobInput);
    }
  }
}
