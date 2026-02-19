import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentService {
  static String get _androidApiKey => dotenv.get('REVENUECAT_GOOGLE_KEY');
  static const _iosApiKey = 'appl_your_actual_key_here';

  static Future<void> init() async {
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

    // Sync user ID with RevenueCat
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await Purchases.logIn(user.uid);
    }
  }

  static Future<bool> purchaseCredits() async {
    try {
      // Fetch offerings
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
        // Find the pack (look for 'credits' or the first one if only one exists)
        final package = offerings.current!.availablePackages.firstWhere(
          (pkg) => pkg.identifier.contains('credits'),
          orElse: () => offerings.current!.availablePackages.first,
        );

        // ignore: deprecated_member_use
        await Purchases.purchasePackage(package);
        
        // RevenueCat webhook will handle the backend credit update
        return true;
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        rethrow;
      }
    }
    return false;
  }
  static Future<bool> presentPaywall() async {
    try {
      final paywallResult = await RevenueCatUI.presentPaywall();
      return paywallResult == PaywallResult.purchased;
    } on PlatformException catch (e) {
      print('Paywall Error: $e');
      return false;
    }
  }

  static Future<bool> presentPaywallIfNeeded() async {
    try {
      final paywallResult = await RevenueCatUI.presentPaywallIfNeeded('premium');
      return paywallResult == PaywallResult.purchased;
    } on PlatformException catch (e) {
      print('Paywall Error: $e');
      return false;
    }
  }
}
