import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/analytics_service.dart';
import 'benefit_item.dart';

class SubscriptionPaywall extends ConsumerStatefulWidget {
  const SubscriptionPaywall({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true, // Ensure it covers bottom nav
      backgroundColor: Colors.transparent,
      builder: (context) => const SubscriptionPaywall(),
    );
  }

  @override
  ConsumerState<SubscriptionPaywall> createState() =>
      _SubscriptionPaywallState();
}

class _SubscriptionPaywallState extends ConsumerState<SubscriptionPaywall> {
  Package? _selectedPackage;
  List<Package> _packages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        setState(() {
          _packages = offerings.current!.availablePackages;
          if (_packages.isNotEmpty) {
            _selectedPackage = _packages.first;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading offerings: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handlePurchase() async {
    if (_selectedPackage == null) return;

    setState(() => _isLoading = true);
    try {
      PurchaseResult result = await Purchases.purchase(
        PurchaseParams.package(_selectedPackage!),
      );
      if (result.customerInfo.entitlements.all['job_hunter_pass']?.isActive ??
          false) {
        AnalyticsService().trackEvent(
          'subscription_purchased',
          properties: {
            'package': _selectedPackage!.identifier,
            'product_id': _selectedPackage!.storeProduct.identifier,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: _buildTitle(l10n),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildBenefitsGrid(l10n, colorScheme),
                    const SizedBox(height: 24),
                    if (_isLoading && _packages.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else
                      _buildPricingOptions(colorScheme, textTheme),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildFooter(l10n, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.vibrantPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            l10n.jobHunterPass.toUpperCase(),
            style: const TextStyle(
              color: AppColors.vibrantPurple,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.unlockYourPotential,
          style: const TextStyle(
            fontSize: 26, // Reduced for compactness
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsGrid(AppLocalizations l10n, ColorScheme colorScheme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        BenefitItem(
          icon: Icons.auto_awesome,
          title: l10n.unlimitedGenerations,
          isCompact: true,
        ),
        BenefitItem(
          icon: Icons.style,
          title: l10n.premiumTemplates,
          isCompact: true,
        ),
        BenefitItem(
          icon: Icons.psychology,
          title: l10n.aiOptimization,
          isCompact: true,
        ),
        BenefitItem(
          icon: Icons.file_download_outlined,
          title: l10n.instantPdfExport,
          isCompact: true,
        ),
      ],
    );
  }

  Widget _buildPricingOptions(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: _packages.map((package) {
        final isSelected = _selectedPackage?.identifier == package.identifier;
        return GestureDetector(
          onTap: () => setState(() => _selectedPackage = package),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      Text(
                        package.storeProduct.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        package.storeProduct.description,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
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

  Widget _buildFooter(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handlePurchase,
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
          const SizedBox(height: 16),
          Text(
            l10n.cancelAnytime,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
