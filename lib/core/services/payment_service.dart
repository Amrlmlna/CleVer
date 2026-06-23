import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/analytics_service.dart';
import '../../presentation/wallet/widgets/subscription_paywall.dart';

class PaymentService {
  static String get _androidApiKey => dotenv.get('REVENUECAT_GOOGLE_KEY');
  static String get _iosApiKey => dotenv.env['REVENUECAT_IOS_KEY'] ?? '';

  static final _analytics = AnalyticsService();

  static Future<void> init() async {
    try {
      await Purchases.setLogLevel(LogLevel.debug);

      PurchasesConfiguration configuration;
      if (!kIsWeb && Platform.isAndroid) {
        configuration = PurchasesConfiguration(_androidApiKey);
      } else if (!kIsWeb && Platform.isIOS) {
        configuration = PurchasesConfiguration(_iosApiKey);
      } else {
        return;
      }

      await Purchases.configure(configuration);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await Purchases.logIn(user.uid);
      }
    } catch (e) {
      _analytics.trackEvent(
        'payment_service_init_error',
        properties: {'error': e.toString()},
      );
    }
  }

  static Future<bool> purchasePackage(String packageIdentifier) async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        final package = offerings.current!.availablePackages.firstWhere(
          (pkg) =>
              pkg.identifier.contains(packageIdentifier) ||
              pkg.storeProduct.identifier.contains(packageIdentifier),
          orElse: () {
            debugPrint(
              'Warning: Package $packageIdentifier not found among: ${offerings.current!.availablePackages.map((e) => '\n- pkgId: ${e.identifier}, prodId: ${e.storeProduct.identifier}').join()}',
            );
            return offerings.current!.availablePackages.first;
          },
        );

        await Purchases.purchase(PurchaseParams.package(package));

        _analytics.trackEvent(
          'purchase_completed',
          properties: {'package': package.identifier},
        );
        return true;
      }
      _analytics.trackEvent(
        'purchase_failed',
        properties: {'reason': 'no_packages'},
      );
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        _analytics.trackEvent(
          'purchase_failed',
          properties: {
            'code': errorCode.toString(),
            'message': e.message ?? '',
          },
        );
        rethrow;
      }
      _analytics.trackEvent('purchase_cancelled');
    } catch (e) {
      _analytics.trackEvent(
        'purchase_failed',
        properties: {'error': e.toString(), 'reason': 'generic'},
      );
    }
    return false;
  }

  static Future<bool> presentPaywall(BuildContext context) async {
    try {
      // Load offerings BEFORE showing the paywall
      final offerings = await Purchases.getOfferings();
      final packages = offerings.current?.availablePackages ?? [];

      if (packages.isEmpty) {
        _analytics.trackEvent(
          'paywall_error',
          properties: {'reason': 'no_packages_available'},
        );
        return false;
      }

      if (!context.mounted) return false;
      final success = await SubscriptionPaywall.show(context, packages);
      return success ?? false;
    } catch (e) {
      _analytics.trackEvent(
        'paywall_error',
        properties: {'error': e.toString()},
      );
      return false;
    }
  }

  static Future<void> login(String uid) async {
    try {
      await Purchases.logIn(uid);
    } catch (e) {
      _analytics.trackEvent(
        'payment_login_error',
        properties: {'error': e.toString()},
      );
    }
  }

  static Future<void> logout() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      _analytics.trackEvent(
        'payment_logout_error',
        properties: {'error': e.toString()},
      );
    }
  }
}
