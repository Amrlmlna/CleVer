import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../templates/providers/template_provider.dart';
import 'package:flutter/foundation.dart';

final paymentSyncProvider = Provider<PaymentSyncManager>((ref) {
  return PaymentSyncManager(ref);
});

class PaymentSyncManager {
  final Ref _ref;

  PaymentSyncManager(this._ref);

  void init() {
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _ref.invalidate(templatesProvider);
    });
  }
}
