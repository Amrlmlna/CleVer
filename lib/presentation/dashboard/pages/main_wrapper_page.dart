import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../core/services/notification_controller.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/in_app_notification.dart';
import '../../onboarding/providers/onboarding_auth_capture_provider.dart';
import '../providers/dashboard_tutorial_provider.dart';
import '../widgets/floating_action_circle.dart';
import '../widgets/floating_navbar_capsule.dart';
import '../widgets/dashboard_tutorial_factory.dart';
import '../utils/dashboard_verification_handler.dart';
import '../utils/dashboard_navigation_handler.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class MainWrapperPage extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainWrapperPage({super.key, required this.navigationShell});

  @override
  ConsumerState<MainWrapperPage> createState() => _MainWrapperPageState();
}

class _MainWrapperPageState extends ConsumerState<MainWrapperPage> {
  final GlobalKey _draftsKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();
  TutorialCoachMark? _navTutorialCoachMark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkEmailVerification();
      if (ref.read(onboardingAuthCaptureProvider)) _handleOnboardingSuccess();
    });

    NotificationController.displayStreamController.stream.listen((n) {
      if (!mounted) return;
      InAppNotificationOverlay.show(
        context,
        title: n.title?.isNotEmpty == true
            ? n.title!
            : AppLocalizations.of(context)!.notificationNew,
        body: n.body ?? '',
      );
    });
  }

  void _checkEmailVerification() =>
      DashboardVerificationHandler.checkVerification(
        context,
        ref.read(authStateProvider).value,
      );

  void _onTabTap(int index) => DashboardNavigationHandler.onTabTap(
    context: context,
    ref: ref,
    navigationShell: widget.navigationShell,
    index: index,
  );

  void _handleOnboardingSuccess() =>
      DashboardNavigationHandler.handleOnboardingSuccess(
        context: context,
        ref: ref,
      );

  void _initNavTutorial() {
    _navTutorialCoachMark = DashboardTutorialFactory.create(
      context: context,
      draftsKey: _draftsKey,
      profileKey: _profileKey,
      onTabTap: _onTabTap,
      onComplete: () {
        ref.read(navigationTutorialPendingProvider.notifier).state = false;
        setState(() => _navTutorialCoachMark = null);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (_, __) => _checkEmailVerification());
    ref.listen(onboardingAuthCaptureProvider, (_, next) {
      if (next) _handleOnboardingSuccess();
    });
    ref.listen(navigationTutorialPendingProvider, (_, next) {
      if (next) {
        _initNavTutorial();
        _navTutorialCoachMark?.show(context: context);
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: widget.navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              FloatingNavbarCapsule(
                currentIndex: widget.navigationShell.currentIndex,
                onTabTap: _onTabTap,
                draftsKey: _draftsKey,
                profileKey: _profileKey,
              ),
              const SizedBox(width: 12),
              const FloatingActionCircle(),
            ],
          ),
        ),
      ),
    );
  }
}
