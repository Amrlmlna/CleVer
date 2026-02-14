import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/welcome_header.dart';
import '../widgets/progress_banner.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/login_cta_card.dart';
import '../widgets/premium_banner.dart';

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
              
              // Welcome Header
              const WelcomeHeader(),
              const SizedBox(height: 24),
              
              // Progress Banner
              const ProgressBanner(),
              const SizedBox(height: 24),
              
              // Quick Actions (3 items)
              const HomeQuickActions(),
              const SizedBox(height: 32),
              
              // Login CTA (conditional)
              const LoginCTACard(),
              const SizedBox(height: 16),
              
              // Premium Banner (conditional)
              const PremiumBanner(),
              
              const SizedBox(height: 100), // Bottom padding for nav
            ],
          ),
        ),
      ),
    );
  }
}
