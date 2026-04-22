import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/review_service.dart';
import '../../../core/services/tutorial_service.dart';
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

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await ReviewService().requestReviewWithBlur(context);

        final hasGenerated = await ReviewService().hasGeneratedAtLeastOneCv();
        final hasShown = await TutorialService().hasShownNavTutorial();

        if (hasGenerated && !hasShown) {
          ref.read(navigationTutorialPendingProvider.notifier).state = true;
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
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
