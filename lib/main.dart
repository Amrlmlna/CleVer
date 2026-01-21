import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/onboarding/providers/onboarding_provider.dart';
import 'presentation/profile/providers/profile_provider.dart';
import 'domain/entities/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check onboarding status and load master profile
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
  
  UserProfile? initialProfile;
  final profileJson = prefs.getString('master_profile_data');
  if (profileJson != null) {
    try {
      initialProfile = UserProfile.fromJson(jsonDecode(profileJson));
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  runApp(ProviderScope(
    overrides: [
      // Initialize providers with stored values
      onboardingProvider.overrideWith((ref) {
        return OnboardingNotifier(initialState: onboardingCompleted);
      }),
      masterProfileProvider.overrideWith((ref) {
        return MasterProfileNotifier(initialState: initialProfile);
      }),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CV Master',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
