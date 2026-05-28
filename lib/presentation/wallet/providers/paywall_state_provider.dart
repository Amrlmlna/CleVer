import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../core/services/analytics_service.dart';

// ─── STATE ─────────────────────────────────────────────────────────────

class PaywallState {
  final List<Package> mainPackages;
  final Package? downsellPackage;
  final Package? selectedPackage;
  final bool isLoading;
  final bool showDownsell;
  final bool showConfetti;

  const PaywallState({
    this.mainPackages = const [],
    this.downsellPackage,
    this.selectedPackage,
    this.isLoading = false,
    this.showDownsell = false,
    this.showConfetti = false,
  });

  PaywallState copyWith({
    List<Package>? mainPackages,
    Package? downsellPackage,
    Package? selectedPackage,
    bool? isLoading,
    bool? showDownsell,
    bool? showConfetti,
  }) {
    return PaywallState(
      mainPackages: mainPackages ?? this.mainPackages,
      downsellPackage: downsellPackage ?? this.downsellPackage,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      isLoading: isLoading ?? this.isLoading,
      showDownsell: showDownsell ?? this.showDownsell,
      showConfetti: showConfetti ?? this.showConfetti,
    );
  }
}

// ─── NOTIFIER ──────────────────────────────────────────────────────────

class PaywallStateNotifier extends StateNotifier<PaywallState> {
  final List<Package> _allPackages;

  PaywallStateNotifier(this._allPackages) : super(const PaywallState()) {
    _init();
  }

  void _init() {
    final main = _allPackages.where((p) {
      final id = p.identifier.toLowerCase();
      final productId = p.storeProduct.identifier.toLowerCase();
      return !(id.contains('24h') || productId.contains('24h'));
    }).toList()..sort((a, b) => _sortOrder(a).compareTo(_sortOrder(b)));

    Package? downsell;
    try {
      downsell = _allPackages.firstWhere((p) {
        final id = p.identifier.toLowerCase();
        final productId = p.storeProduct.identifier.toLowerCase();
        return id.contains('24h') || productId.contains('24h');
      });
    } catch (_) {}

    state = state.copyWith(
      mainPackages: main,
      downsellPackage: downsell,
      selectedPackage: main.isNotEmpty ? main.first : null,
    );
  }

  void selectPackage(Package package) {
    state = state.copyWith(selectedPackage: package);
  }

  static int _sortOrder(Package p) {
    final id = '${p.identifier} ${p.storeProduct.identifier}'.toLowerCase();
    if (id.contains('weekly') || id.contains('minggu')) return 0;
    if (id.contains('monthly') || id.contains('bulan')) return 1;
    if (id.contains('yearly') || id.contains('tahun')) return 2;
    if (id.contains('3d') || id.contains('3 hari')) return 3;
    return 99;
  }

  /// Returns true if purchase succeeded and entitlement is active.
  Future<bool> purchase(String source) async {
    final package = state.selectedPackage;
    if (package == null) return false;

    state = state.copyWith(isLoading: true);
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      final active =
          result.customerInfo.entitlements.all['job_hunter_pass']?.isActive ??
          false;
      if (active) {
        AnalyticsService().trackEvent(
          'subscription_purchased',
          properties: {
            'package': package.identifier,
            'product_id': package.storeProduct.identifier,
            'source': source,
          },
        );
        AnalyticsService().trackPaywallInteraction(
          'purchase_success',
          packageId: package.identifier,
        );
      }
      return active;
    } catch (e) {
      debugPrint('Purchase error: $e');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Returns true if downsell was triggered, false if should dismiss.
  bool triggerDownsell() {
    if (state.showDownsell || state.downsellPackage == null) return false;
    state = state.copyWith(showDownsell: true, showConfetti: true);
    return true;
  }
}

// ─── PROVIDER ──────────────────────────────────────────────────────────

final paywallStateProvider = StateNotifierProvider.autoDispose
    .family<PaywallStateNotifier, PaywallState, List<Package>>(
      (ref, packages) => PaywallStateNotifier(packages),
    );
