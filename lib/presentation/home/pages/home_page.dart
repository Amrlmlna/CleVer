import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/review_service.dart';
import '../../../core/services/tutorial_service.dart';
import '../providers/paywall_provider.dart';
import '../providers/review_check_provider.dart';
import '../../wallet/widgets/credit_purchase_bottom_sheet.dart';
import '../../dashboard/providers/dashboard_tutorial_provider.dart';

import '../widgets/huge_profile_header.dart';
import '../widgets/bento_quick_actions.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

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
      final hasPendingPaywall = ref.read(pendingPaywallProvider);
      if (hasPendingPaywall) {
        ref.read(pendingPaywallProvider.notifier).state = false;
        await CreditPurchaseBottomSheet.show(context);
      }

      final reviewSignal = ref.read(reviewCheckProvider);
      if (reviewSignal > 0) {
        ref.read(reviewCheckProvider.notifier).state = 0;
        await _triggerReviewAndTutorials();
        return;
      }

      await _triggerReviewAndTutorials();
    } finally {
      _isCheckingPrompts = false;
    }
  }

  Future<void> _triggerReviewAndTutorials() async {
    if (!mounted) return;

    await ReviewService().requestReviewWithBlur(context);

    if (!mounted) return;
    final hasGenerated = await ReviewService().hasGeneratedAtLeastOneCv();
    final hasShown = await TutorialService().hasShownNavTutorial();
    if (hasGenerated && !hasShown && mounted) {
      ref.read(navigationTutorialPendingProvider.notifier).state = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(reviewCheckProvider);
    ref.watch(pendingPaywallProvider);

    ref.listen(reviewCheckProvider, (previous, next) {
      if (next > 0 && mounted) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          _checkAndShowSequentialPrompts();
        }
      }
    });

    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HugeProfileHeader(),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                l10n.quickActions.toUpperCase(),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const BentoQuickActions(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
