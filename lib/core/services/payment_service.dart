import 'dart:io';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/analytics_service.dart';
import '../../presentation/wallet/widgets/credit_purchase_bottom_sheet.dart';

class PaymentService {
  static String get _androidApiKey => dotenv.get('REVENUECAT_GOOGLE_KEY');
  static const _iosApiKey = 'appl_your_actual_key_here';

  static final _analytics = AnalyticsService();

  static Future<void> init() async {
    try {
      await Purchases.setLogLevel(LogLevel.debug);

      PurchasesConfiguration configuration;
      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(_androidApiKey);
      } else if (Platform.isIOS) {
        configuration = PurchasesConfiguration(_iosApiKey);
      } else {
        return;
      }

      await Purchases.configure(configuration);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await Purchases.logIn(user.uid);
      }
      _analytics.trackEvent('payment_service_init_success');
    } catch (e) {
      _analytics.trackEvent(
        'payment_service_init_error',
        properties: {'error': e.toString()},
      );
    }
  }

  static Future<bool> purchaseCredits() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        final package = offerings.current!.availablePackages.firstWhere(
          (pkg) => pkg.identifier.contains('credits'),
          orElse: () => offerings.current!.availablePackages.first,
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
      _analytics.trackEvent('paywall_viewed');
      final success = await CreditPurchaseBottomSheet.show(context);
      _analytics.trackEvent(
        'paywall_dismissed',
        properties: {'purchased': success},
      );
      return success;
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
      _analytics.trackEvent('payment_login_success', properties: {'uid': uid});
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
      _analytics.trackEvent('payment_logout_success');
    } catch (e) {
      _analytics.trackEvent(
        'payment_logout_error',
        properties: {'error': e.toString()},
      );
    }
  }
}
