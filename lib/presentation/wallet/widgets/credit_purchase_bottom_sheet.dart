import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/services/payment_service.dart';
import '../models/credit_package.dart';
import 'benefit_item.dart';
import 'package_card.dart';

class CreditPurchaseBottomSheet extends ConsumerStatefulWidget {
  const CreditPurchaseBottomSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    final result = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
      builder: (_) => const CreditPurchaseBottomSheet(),
    );
    return result ?? false;
  }

  @override
  ConsumerState<CreditPurchaseBottomSheet> createState() =>
      _CreditPurchaseBottomSheetState();
}

class _CreditPurchaseBottomSheetState
    extends ConsumerState<CreditPurchaseBottomSheet> {
  bool _isPurchasing = false;
  int _selectedIndex = 1;

  late final List<CreditPackage> _packages;

  @override
  void initState() {
    super.initState();
    _packages = [
      CreditPackage(
        id: 'clever_credits_25',
        credits: 25,
        nameBuilder: (l10n) => l10n.packageSmall,
        priceIdr: 'Rp29.000',
        priceUsd: '\$1.79',
        perCreditIdr: 'Rp1.160',
        perCreditUsd: '\$0.07',
      ),
      CreditPackage(
        id: 'clever_credits_50',
        credits: 55,
        nameBuilder: (l10n) => l10n.packageMedium,
        priceIdr: 'Rp49.000',
        priceUsd: '\$2.99',
        perCreditIdr: 'Rp890',
        perCreditUsd: '\$0.05',
        savingsPercent: 23,
        isPopular: true,
      ),
      CreditPackage(
        id: 'clever_credits_100',
        credits: 120,
        nameBuilder: (l10n) => l10n.packagePro,
        priceIdr: 'Rp99.000',
        priceUsd: '\$5.99',
        perCreditIdr: 'Rp825',
        perCreditUsd: '\$0.05',
        savingsPercent: 29,
      ),
    ];
  }

  Future<void> _handlePurchase() async {
    if (_isPurchasing) return;
    setState(() => _isPurchasing = true);

    try {
      final package = _packages[_selectedIndex];
      final success = await PaymentService.purchasePackage(package.id);
      if (mounted) {
        Navigator.of(context).pop(success);
      }
    } catch (_) {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeNotifierProvider);
    final isIdr = locale.languageCode == 'id';
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24,
                8,
                24,
                24 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  Text(
                    l10n.getCredits.toUpperCase(),
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 32),

                  BenefitItem(
                    icon: Icons.auto_awesome_outlined,
                    title: l10n.benefitRegularTitle,
                    description: l10n.benefitRegularDesc,
                  ),
                  const SizedBox(height: 16),
                  BenefitItem(
                    icon: Icons.verified_outlined,
                    title: l10n.benefitPremiumTitle,
                    description: l10n.benefitPremiumDesc,
                  ),
                  const SizedBox(height: 16),
                  BenefitItem(
                    icon: Icons.bolt_outlined,
                    title: l10n.benefitSkipAdsTitle,
                    description: l10n.benefitSkipAdsDesc,
                  ),

                  const SizedBox(height: 40),

                  ..._packages.asMap().entries.map((entry) {
                    final index = entry.key;
                    final pkg = entry.value;
                    final isSelected = _selectedIndex == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PackageCard(
                        package: pkg,
                        l10n: l10n,
                        isIdr: isIdr,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedIndex = index),
                      ),
                    );
                  }),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isPurchasing ? null : _handlePurchase,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.onSurface,
                        foregroundColor: colorScheme.surface,
                        disabledBackgroundColor: colorScheme.onSurface.withValues(
                          alpha: 0.3,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isPurchasing
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: colorScheme.surface,
                              ),
                            )
                          : Text(
                              l10n.getCredits.toUpperCase(),
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: colorScheme.surface,
                                letterSpacing: 1.0,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      l10n.skipForNow,
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.securePayment,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
