import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/unsaved_changes_dialog.dart';
import '../../profile/providers/profile_provider.dart';
import '../../onboarding/providers/onboarding_auth_capture_provider.dart';
import '../../../core/router/app_routes.dart';

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
            onDiscard: () async {
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

    // Auth-first onboarding: users completing the panel are always
    // authenticated, so the legacy forced auth wall here is dead. Straight
    // into the momentum flow.
    context.push(AppRoutes.createJobInput);
  }
}
