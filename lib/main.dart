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
import 'presentation/profile/providers/profile_sync_provider.dart';
import 'presentation/drafts/providers/draft_sync_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'core/providers/locale_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/services/ad_service.dart';
import 'core/services/payment_service.dart';
import 'core/services/permission_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/app_update_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );

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

  runApp(
    ProviderScope(
      overrides: [
        onboardingProvider.overrideWith((ref) {
          return OnboardingNotifier(initialState: onboardingCompleted);
        }),
        masterProfileProvider.overrideWith((ref) {
          return MasterProfileNotifier(initialState: initialProfile);
        }),
      ],
      child: const BootstrapApp(),
    ),
  );
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
    PaintingBinding.instance.imageCache.maximumSizeBytes = 300 * 1024 * 1024;

    if (mounted) {
      setState(() => _isReady = true);
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const MaterialApp(
        home: Scaffold(backgroundColor: Colors.transparent),
        debugShowCheckedModeBanner: false,
      );
    }

    return const MyApp();
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileSyncProvider).init();
      ref.read(draftSyncProvider).init();
      ref.read(localeNotifierProvider.notifier).init();

      _initBackgroundServices();
    });
  }

  Future<void> _initBackgroundServices() async {
    try {
      await PaymentService.init();
      await adService.init();
      await NotificationService.init();
      await NotificationService.requestPermissions();
      PermissionService.requestAllPermissions();
      AppUpdateService().checkForUpdate();
    } catch (e) {
      debugPrint('Error initializing background services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeNotifierProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        NotificationService.updateChannelLocalization(
          cvChannelName: l10n.notificationChannelCVTitle,
          cvChannelDesc: l10n.notificationChannelCVDesc,
          generalChannelName: l10n.notificationChannelGeneralTitle,
          generalChannelDesc: l10n.notificationChannelGeneralDesc,
        );
      }
    });

    return MaterialApp.router(
      title: 'CV Master',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('id')],
    );
  }
}
