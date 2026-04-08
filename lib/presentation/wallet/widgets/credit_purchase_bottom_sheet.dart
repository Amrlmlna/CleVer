import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/services/payment_service.dart';
import '../models/credit_package.dart';
import 'benefit_item.dart';
import 'package_card.dart';
import 'liquid_glass_sheet_painter.dart';

class CreditPurchaseBottomSheet extends ConsumerStatefulWidget {
  const CreditPurchaseBottomSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
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


    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
        child: CustomPaint(
          painter: LiquidGlassSheetPainter(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                24 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 28),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Text(
                    l10n.getCredits,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  BenefitItem(
                    icon: Icons.description_outlined,
                    title: l10n.benefitRegularTitle,
                    description: l10n.benefitRegularDesc,
                  ),
                  const SizedBox(height: 12),
                  BenefitItem(
                    icon: Icons.workspace_premium_outlined,
                    title: l10n.benefitPremiumTitle,
                    description: l10n.benefitPremiumDesc,
                  ),
                  const SizedBox(height: 12),
                  BenefitItem(
                    icon: Icons.block_outlined,
                    title: l10n.benefitSkipAdsTitle,
                    description: l10n.benefitSkipAdsDesc,
                  ),

                  const SizedBox(height: 28),

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

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isPurchasing ? null : _handlePurchase,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.white.withValues(
                          alpha: 0.3,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isPurchasing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              l10n.getCredits,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        l10n.skipForNow,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.securePayment,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
