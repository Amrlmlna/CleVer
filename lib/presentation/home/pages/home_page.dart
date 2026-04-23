import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/review_service.dart';
import '../../../core/services/tutorial_service.dart';
import '../providers/paywall_provider.dart';
import '../providers/review_check_provider.dart';
import '../../wallet/widgets/credit_purchase_bottom_sheet.dart';
import '../../dashboard/providers/dashboard_tutorial_provider.dart';

import '../widgets/carousel_banner.dart';
import '../widgets/welcome_header.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/login_cta_card.dart';
import '../widgets/premium_banner.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initial check on app start
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _checkAndShowSequentialPrompts(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndShowSequentialPrompts();
    }
  }

  bool _isCheckingPrompts = false;

  Future<void> _checkAndShowSequentialPrompts() async {
    if (_isCheckingPrompts || !mounted) return;
    _isCheckingPrompts = true;

    try {
      // 1. Check for Pending Paywall (from CV Export)
      final hasPendingPaywall = ref.read(pendingPaywallProvider);
      if (hasPendingPaywall) {
        ref.read(pendingPaywallProvider.notifier).state = false;
        // We AWAIT the paywall so review doesn't overlap
        await CreditPurchaseBottomSheet.show(context);
      }

      // 2. Check for Review Signal (from CV Export)
      final reviewSignal = ref.read(reviewCheckProvider);
      if (reviewSignal > 0) {
        // Clear signal so it doesn't fire again on next resume
        ref.read(reviewCheckProvider.notifier).state = 0;
        await _triggerReviewAndTutorials();
        return; // Success flow ends here
      }

      // 3. Fallback for General App Usage (Initial Load)
      // If no signal, still check if we should show review/tutorials based on general rules
      await _triggerReviewAndTutorials();
    } finally {
      _isCheckingPrompts = false;
    }
  }

  Future<void> _triggerReviewAndTutorials() async {
    if (!mounted) return;

    // 2a. Review Prompt
    await ReviewService().requestReviewWithBlur(context);

    // 2b. Tutorial Tooltip
    if (!mounted) return;
    final hasGenerated = await ReviewService().hasGeneratedAtLeastOneCv();
    final hasShown = await TutorialService().hasShownNavTutorial();
    if (hasGenerated && !hasShown && mounted) {
      ref.read(navigationTutorialPendingProvider.notifier).state = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // WATCH: This ensures HomePage rebuilds as soon as generation is successful.
    // When the user pops back from Preview, this rebuild is what triggers the check.
    ref.watch(reviewCheckProvider);
    ref.watch(pendingPaywallProvider);

    // LIVE SIGNAL: Listen for the ping from TemplatePreviewPage
    ref.listen(reviewCheckProvider, (previous, next) {
      if (next > 0 && mounted) {
        // ONLY trigger if we are the current route (not in the background)
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          _checkAndShowSequentialPrompts();
        }
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const WelcomeHeader(),
              const SizedBox(height: 24),

              const CarouselBanner(),
              const SizedBox(height: 16),

              const HomeQuickActions(),
              const SizedBox(height: 32),

              const LoginCTACard(),
              const SizedBox(height: 16),

              const PremiumBanner(),
              const SizedBox(height: 24),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
