import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/analytics_service.dart';

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
      _analytics.trackEvent('payment_service_init_error', properties: {'error': e.toString()});
    }
  }

  static Future<bool> purchaseCredits() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
        final package = offerings.current!.availablePackages.firstWhere(
          (pkg) => pkg.identifier.contains('credits'),
          orElse: () => offerings.current!.availablePackages.first,
        );

        await Purchases.purchase(PurchaseParams.package(package));
        
        _analytics.trackEvent('purchase_attempt_success', properties: {'package': package.identifier});
        return true;
      }
      _analytics.trackEvent('purchase_attempt_fail', properties: {'reason': 'no_packages'});
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        _analytics.trackEvent('purchase_error', properties: {'code': errorCode.toString(), 'message': e.message ?? ''});
        rethrow;
      }
      _analytics.trackEvent('purchase_cancelled');
    } catch (e) {
      _analytics.trackEvent('purchase_error_generic', properties: {'error': e.toString()});
    }
    return false;
  }

  static Future<bool> presentPaywall() async {
    try {
      final paywallResult = await RevenueCatUI.presentPaywall();
      final success = paywallResult == PaywallResult.purchased;
      _analytics.trackEvent('paywall_closed', properties: {'purchased': success});
      return success;
    } on PlatformException catch (e) {
      _analytics.trackEvent('paywall_error', properties: {'error': e.toString()});
      return false;
    }
  }

  static Future<bool> presentPaywallIfNeeded() async {
    try {
      final paywallResult = await RevenueCatUI.presentPaywallIfNeeded('premium');
      final success = paywallResult == PaywallResult.purchased;
      _analytics.trackEvent('paywall_if_needed_closed', properties: {'purchased': success});
      return success;
    } on PlatformException catch (e) {
      _analytics.trackEvent('paywall_error', properties: {'error': e.toString()});
      return false;
    }
  }
}
