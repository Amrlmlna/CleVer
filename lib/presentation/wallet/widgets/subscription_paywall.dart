import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/services/analytics_service.dart';
import '../../home/widgets/mascot_header.dart';
import '../../home/models/mascot_state.dart';

class SubscriptionPaywall extends ConsumerStatefulWidget {
  final List<Package> packages;

  const SubscriptionPaywall({super.key, required this.packages});

  static Future<bool?> show(BuildContext context, List<Package> packages) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => SubscriptionPaywall(packages: packages),
    );
  }

  static String getDisplayName(String? rawName, AppLocalizations l10n) {
    if (rawName == null) return l10n.jobHunterPass;
    final lower = rawName.toLowerCase();
    if (lower.contains('24h') || lower.contains('24 jam')) return l10n.product24hTitle;
    if (lower.contains('3d') || lower.contains('3 hari')) return l10n.product3dTitle;
    if (lower.contains('weekly') || lower.contains('minggu')) return l10n.productWeeklyTitle;
    if (lower.contains('monthly') || lower.contains('bulan')) return l10n.productMonthlyTitle;
    if (lower.contains('yearly') || lower.contains('tahun')) return l10n.productYearlyTitle;
    return l10n.jobHunterPass;
  }

  @override
  ConsumerState<SubscriptionPaywall> createState() =>
      _SubscriptionPaywallState();
}

class _SubscriptionPaywallState extends ConsumerState<SubscriptionPaywall> {
  Package? _selectedPackage;
  bool _isLoading = false;
  bool _showDownsell = false;

  late final List<Package> _mainPackages;

  @override
  void initState() {
    super.initState();
    // Filter out 24h pass — it's handled by the downsell
    _mainPackages = widget.packages.where((p) {
      final id = p.identifier.toLowerCase();
      final productId = p.storeProduct.identifier.toLowerCase();
      return !(id.contains('24h') || productId.contains('24h'));
    }).toList();
    if (_mainPackages.isNotEmpty) {
      _selectedPackage = _mainPackages.first;
    }
  }

  static (String, String) _getProductName(Package package, AppLocalizations l10n) {
    final id = '${package.identifier} ${package.storeProduct.identifier}'.toLowerCase();
    if (id.contains('24h')) return (l10n.product24hTitle, l10n.product24hDesc);
    if (id.contains('3d')) return (l10n.product3dTitle, l10n.product3dDesc);
    if (id.contains('weekly')) return (l10n.productWeeklyTitle, l10n.productWeeklyDesc);
    if (id.contains('monthly')) return (l10n.productMonthlyTitle, l10n.productMonthlyDesc);
    if (id.contains('yearly')) return (l10n.productYearlyTitle, l10n.productYearlyDesc);
    return (l10n.jobHunterPass, '');
  }

  Package? get _downsellPackage {
    try {
      return widget.packages.firstWhere((p) {
        final id = p.identifier.toLowerCase();
        final productId = p.storeProduct.identifier.toLowerCase();
        return id.contains('24h') || productId.contains('24h');
      });
    } catch (_) {
      return null;
    }
  }

  Future<void> _handlePurchase(Package package, String source) async {
    setState(() => _isLoading = true);
    try {
      PurchaseResult result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      if (result.customerInfo.entitlements.all['job_hunter_pass']?.isActive ??
          false) {
        AnalyticsService().trackEvent(
          'subscription_purchased',
          properties: {
            'package': package.identifier,
            'product_id': package.storeProduct.identifier,
            'source': source,
          },
        );
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Purchase error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onPopInvoked(bool didPop) {
    if (didPop) return;

    // Intercept dismissal — switch to downsell if available
    final downsell = _downsellPackage;
    if (!_showDownsell && downsell != null) {
      setState(() => _showDownsell = true);
    } else {
      // Already on downsell or no downsell available — actually close
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _onPopInvoked(didPop),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          child: _showDownsell ? _buildDownsell() : _buildMain(),
        ),
      ),
    );
  }

  // ─── MAIN PAYWALL ──────────────────────────────────────────────────────

  Widget _buildMain() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHandle(colorScheme),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: MascotHeader(
            expression: MascotExpression.exciting,
            mascotColor: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        _buildMainHeadline(l10n, colorScheme, textTheme),
        const SizedBox(height: 24),
        _buildBenefits(l10n, colorScheme, textTheme),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildPricing(colorScheme, textTheme, l10n),
          ),
        ),
        _buildMainCTA(l10n, colorScheme, textTheme),
        _buildTrust(
          l10n.cancelAnytimeSecure,
          colorScheme,
          textTheme,
        ),
        _buildCloseHint(colorScheme, textTheme),
      ],
    );
  }

  Widget _buildMainHeadline(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.paywallHeadline.toUpperCase(),
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              color: colorScheme.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.paywallSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCTA(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading || _selectedPackage == null
              ? null
              : () => _handlePurchase(_selectedPackage!, 'main_paywall'),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.onSurface,
            foregroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(colorScheme.surface),
                  ),
                )
              : Text(
                  l10n.getJobHunterPassNow.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }

  // ─── DOWNSELL PAYWALL ──────────────────────────────────────────────────

  Widget _buildDownsell() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final downsell = _downsellPackage!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHandle(colorScheme),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: MascotHeader(
            expression: MascotExpression.encouraging,
            mascotColor: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        _buildDownsellHeadline(l10n, colorScheme, textTheme),
        const SizedBox(height: 24),
        _buildDownsellBenefits(l10n, colorScheme, textTheme),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildDownsellCard(downsell, colorScheme, textTheme),
        ),
        const SizedBox(height: 20),
        _buildDownsellCTA(downsell, l10n, colorScheme, textTheme),
        _buildTrust(
          l10n.downsellTrust,
          colorScheme,
          textTheme,
        ),
        _buildCloseHint(colorScheme, textTheme),
      ],
    );
  }

  Widget _buildDownsellHeadline(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.downsellHeadline.toUpperCase(),
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: colorScheme.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.downsellSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownsellBenefits(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final benefits = [
      l10n.downsellBenefitAll,
      l10n.downsellBenefitSame,
      l10n.downsellBenefitInstant,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: benefits
            .map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      benefit,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDownsellCard(
    Package package,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final (title, desc) = _getProductName(package, l10n);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            package.storeProduct.priceString,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownsellCTA(
    Package package,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : () => _handlePurchase(package, 'downsell'),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.onSurface,
            foregroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(colorScheme.surface),
                  ),
                )
              : Text(
                  l10n.downsellCta.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }

  // ─── SHARED ────────────────────────────────────────────────────────────

  Widget _buildHandle(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefits(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final benefits = [
      l10n.unlimitedGenerations,
      l10n.premiumTemplates,
      l10n.aiOptimization,
      l10n.instantPdfExport,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: benefits
            .map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      benefit,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildPricing(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AppLocalizations l10n,
  ) {
    return Column(
      children: _mainPackages.map((package) {
        final isSelected =
            _selectedPackage?.identifier == package.identifier;
        final isBestValue =
            package == _mainPackages.last && _mainPackages.length > 1;
        final (title, desc) = _getProductName(package, l10n);

        return GestureDetector(
          onTap: () => setState(() => _selectedPackage = package),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.05)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (isBestValue) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.tertiary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l10n.bestValue.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: colorScheme.tertiary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (desc.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          desc,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  package.storeProduct.priceString,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrust(
    String text,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildCloseHint(ColorScheme colorScheme, TextTheme textTheme) {
    return GestureDetector(
      onTap: () => _onPopInvoked(false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          'No thanks',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
