import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/carousel_banner.dart';
import '../widgets/welcome_header.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/login_cta_card.dart';
import '../widgets/premium_banner.dart';
import '../widgets/feedback_cta_banner.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

              const FeedbackCTABanner(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
