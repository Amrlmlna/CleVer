import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/onboarding/providers/onboarding_provider.dart';
import 'presentation/profile/providers/profile_provider.dart';
import 'domain/entities/user_profile.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
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
    child: const BootstrapApp(),
  ));
}

class BootstrapApp extends StatefulWidget {
  const BootstrapApp({super.key});

  @override
  State<BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<BootstrapApp> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // 1. Increase Cache Size
    PaintingBinding.instance.imageCache.maximumSizeBytes = 300 * 1024 * 1024; // 300MB

    // 2. Precache Images
    await _precacheSequence();
    
    if (mounted) {
      setState(() => _isReady = true);
      // 3. Remove Splash
      FlutterNativeSplash.remove();
    }
  }

  Future<void> _precacheSequence() async {
     try {
      final futures = <Future>[];
      // Frame range 1 to 192
      const startFrame = 1;
      const frameCount = 192;
      
      for (int i = 0; i < frameCount; i++) {
        final frameIndex = startFrame + i;
        final frameStr = frameIndex.toString().padLeft(3, '0');
        final path = 'assets/sequence/ezgif-frame-$frameStr.jpg';
        // Need to use PaintingBinding to precache without Context if possible, 
        // OR standard precacheImage with the current context (which is valid here)
        futures.add(precacheImage(AssetImage(path), context));
      }
      
      await Future.wait(futures);
    } catch (e) {
      debugPrint("Error precaching in Bootstrap: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // While not ready, we show a transparent placeholder.
    // Since Native Splash is PRESERVED, the user sees the Native Splash.
    if (!_isReady) {
      return const MaterialApp(
        home: Scaffold(backgroundColor: Colors.transparent),
        debugShowCheckedModeBanner: false,
      );
    }

    return const MyApp();
  }
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
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Force Dark Mode for Gen Z aesthetic
      routerConfig: router,
    );
  }
}
