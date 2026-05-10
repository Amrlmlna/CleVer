import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:clever/core/theme/app_colors.dart';
import '../../home/widgets/mascot_header.dart';
import '../../home/models/mascot_state.dart';
import '../providers/paywall_state_provider.dart';
import '../utils/product_name_resolver.dart';
import 'confetti_overlay.dart';
import 'package_pill_selector.dart';
import 'paywall_benefit_card.dart';
import 'paywall_transition.dart';
import 'subscription_status_card.dart';

class SubscriptionPaywall extends ConsumerStatefulWidget {
  final List<Package> packages;

  const SubscriptionPaywall({super.key, required this.packages});

  static Future<bool?> show(BuildContext context, List<Package> packages) {
    return PaywallTransition.show(
      context,
      SubscriptionPaywall(packages: packages),
    );
  }

  @override
  ConsumerState<SubscriptionPaywall> createState() =>
      _SubscriptionPaywallState();
}

class _SubscriptionPaywallState extends ConsumerState<SubscriptionPaywall> {
  void _onPopInvoked(bool didPop, PaywallStateNotifier notifier) {
    if (didPop) return;
    if (!notifier.triggerDownsell()) {
      Navigator.pop(context, false);
    }
  }

  Future<void> _handlePurchase(
    PaywallStateNotifier notifier,
    String source,
  ) async {
    final success = await notifier.purchase(source);
    if (success && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(paywallStateProvider(widget.packages).notifier);
    final state = ref.watch(paywallStateProvider(widget.packages));
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _onPopInvoked(didPop, notifier),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Stack(
            children: [
              SafeArea(
                child: state.showDownsell
                    ? _buildDownsell(state, notifier)
                    : _buildMain(state, notifier),
              ),
              ConfettiOverlay(show: state.showConfetti),
            ],
          ),
        ),
      ),
    );
  }

  // ─── MAIN PAYWALL ──────────────────────────────────────────────────────

  Widget _buildMain(PaywallState state, PaywallStateNotifier notifier) {
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
        const SizedBox(height: 20),
        _buildBenefitsGrid(l10n),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: PackagePillSelector(
            packages: state.mainPackages,
            selectedPackage: state.selectedPackage,
            onSelected: notifier.selectPackage,
            l10n: l10n,
          ),
        ),
        const SizedBox(height: 20),
        _buildMainCTA(l10n, colorScheme, textTheme, state, notifier),
        _buildTrust(l10n.cancelAnytimeSecure, colorScheme, textTheme),
        _buildCloseHint(l10n, colorScheme, textTheme, notifier),
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

  Widget _buildBenefitsGrid(AppLocalizations l10n) {
    final benefits = [
      (
        l10n.unlimitedGenerations,
        l10n.unlimitedGenerationsDesc,
        Icons.auto_awesome_rounded,
        AppColors.accentSage,
        AppColors.accentSageDark,
      ),
      (
        l10n.premiumTemplates,
        l10n.premiumTemplatesDesc,
        Icons.design_services_rounded,
        AppColors.accentLavender,
        AppColors.accentLavenderDark,
      ),
      (
        l10n.aiOptimization,
        l10n.aiOptimizationDesc,
        Icons.psychology_rounded,
        AppColors.accentMist,
        AppColors.accentMistDark,
      ),
      (
        l10n.instantPdfExport,
        l10n.instantPdfExportDesc,
        Icons.picture_as_pdf_rounded,
        AppColors.accentLemon,
        AppColors.accentLemonDark,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: benefits
            .map(
              (b) => PaywallBenefitCard(
                title: b.$1,
                description: b.$2,
                icon: b.$3,
                bgColor: b.$4,
                iconColor: b.$5,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildMainCTA(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
    PaywallState state,
    PaywallStateNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: state.isLoading || state.selectedPackage == null
              ? null
              : () => _handlePurchase(notifier, 'main_paywall'),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.onSurface,
            foregroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: state.isLoading
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

  Widget _buildDownsell(PaywallState state, PaywallStateNotifier notifier) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final downsell = state.downsellPackage!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHandle(colorScheme),
        const SizedBox(height: 12),
        _buildDownsellHeadline(l10n, colorScheme, textTheme),
        const SizedBox(height: 20),
        _buildDownsellBenefits(l10n),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildDownsellCard(downsell, colorScheme, textTheme),
        ),
        const SizedBox(height: 20),
        _buildDownsellCTA(
          downsell,
          l10n,
          colorScheme,
          textTheme,
          state,
          notifier,
        ),
        _buildTrust(l10n.downsellTrust, colorScheme, textTheme),
        _buildCloseHint(l10n, colorScheme, textTheme, notifier),
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
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: CustomPaint(
                painter: GuillochePainter(
                  color: colorScheme.onSurface.withValues(alpha: 0.03),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.downsellHeadline.toUpperCase(),
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
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
        ],
      ),
    );
  }

  Widget _buildDownsellBenefits(AppLocalizations l10n) {
    final benefits = [
      (
        l10n.downsellBenefitAll,
        Icons.all_inclusive_rounded,
        AppColors.accentSage,
        AppColors.accentSageDark,
      ),
      (
        l10n.downsellBenefitSame,
        Icons.copy_all_rounded,
        AppColors.accentLavender,
        AppColors.accentLavenderDark,
      ),
      (
        l10n.downsellBenefitInstant,
        Icons.bolt_rounded,
        AppColors.accentLemon,
        AppColors.accentLemonDark,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: benefits
            .map(
              (b) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: b.$3,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: b.$4.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(b.$2, size: 18, color: b.$4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        b.$1,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: b.$4,
                          letterSpacing: -0.2,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
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
    final (title, desc) = ProductNameResolver.resolve(package, l10n);

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
    PaywallState state,
    PaywallStateNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () async {
                  notifier.selectPackage(package);
                  await _handlePurchase(notifier, 'downsell');
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.onSurface,
            foregroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: state.isLoading
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

  Widget _buildCloseHint(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
    PaywallStateNotifier notifier,
  ) {
    return GestureDetector(
      onTap: () => _onPopInvoked(false, notifier),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          l10n.noThanks,
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
