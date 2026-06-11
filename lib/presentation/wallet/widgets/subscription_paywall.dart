import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../home/widgets/mascot_header.dart';
import '../../home/models/mascot_state.dart';
import '../providers/paywall_state_provider.dart';
import '../utils/product_name_resolver.dart';
import '../../templates/providers/template_provider.dart';
import 'confetti_overlay.dart';
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
  void _onPopInvoked(
    bool didPop,
    PaywallStateNotifier notifier,
    bool showDownsell,
  ) {
    if (didPop) return;

    // If we're not showing downsell yet, trigger it
    if (!showDownsell) {
      notifier.triggerDownsell();
    }
  }

  Future<void> _handlePurchase(
    PaywallStateNotifier notifier,
    String source,
    bool isSubscribed,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isSubscribed) {
      final confirmed = await _showUpgradeConfirmation(
        l10n,
        colorScheme,
        textTheme,
      );
      if (confirmed != true) return;
    }

    final success = await notifier.purchase(source);
    if (success && mounted) Navigator.pop(context, true);
  }

  Future<bool?> _showUpgradeConfirmation(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.rocket_launch_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.upgradeToLifetime.toUpperCase(),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.cancelRecurringWarning,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(color: colorScheme.outline),
                        ),
                        child: Text(
                          l10n.cancel.toUpperCase(),
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.onSurface,
                          foregroundColor: colorScheme.surface,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.upgradeNow.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(paywallStateProvider(widget.packages).notifier);
    final state = ref.watch(paywallStateProvider(widget.packages));
    final colorScheme = Theme.of(context).colorScheme;

    final templates = ref.watch(templatesProvider).value ?? [];
    final isSubscribed = templates.any((t) => t.isSubscribed);
    final expiryDate = templates.isNotEmpty
        ? templates.first.subscriptionExpiry
        : null;
    final isLifetime =
        isSubscribed &&
        expiryDate != null &&
        expiryDate.difference(DateTime.now()).inDays > 365 * 10;

    return PopScope(
      canPop: state.showDownsell,
      onPopInvokedWithResult: (didPop, _) =>
          _onPopInvoked(didPop, notifier, state.showDownsell),
      child: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              child: Container(
                color: colorScheme.surface,
                child: state.showDownsell
                    ? _buildDownsell(state, notifier)
                    : _buildMain(state, notifier, isSubscribed, isLifetime),
              ),
            ),
            if (state.showConfetti)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height,
                child: ConfettiOverlay(show: true),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMain(
    PaywallState state,
    PaywallStateNotifier notifier,
    bool isSubscribed,
    bool isLifetime,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(colorScheme),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: MascotHeader(
              expression: isLifetime
                  ? MascotExpression.smiling
                  : MascotExpression.exciting,
              mascotColor: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          _buildMainHeadline(
            l10n,
            colorScheme,
            textTheme,
            isSubscribed,
            isLifetime,
          ),
          const SizedBox(height: 20),
          if (!isLifetime) ...[
            _buildPricingCards(state, notifier, l10n, colorScheme, textTheme),
            const SizedBox(height: 20),
          ],
          _buildMainCTA(
            l10n,
            colorScheme,
            textTheme,
            state,
            notifier,
            isSubscribed,
            isLifetime,
          ),
          _buildCloseHint(l10n, colorScheme, textTheme, notifier),
        ],
      ),
    );
  }

  Widget _buildMainHeadline(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isSubscribed,
    bool isLifetime,
  ) {
    final title = isLifetime
        ? l10n.lifetimeAccessActive
        : (isSubscribed ? l10n.upgradeToLifetime : l10n.paywallHeadline);

    final subtitle = isLifetime
        ? l10n.lifetimeAccessActiveDesc
        : (isSubscribed
              ? l10n.upgradeToLifetimeDesc
              : l10n.paywallSimpleBenefit);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              color: colorScheme.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isLifetime ? Icons.stars_rounded : Icons.check_circle_rounded,
                size: 16,
                color: isLifetime
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCards(
    PaywallState state,
    PaywallStateNotifier notifier,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: List.generate(state.mainPackages.length, (index) {
          final package = state.mainPackages[index];
          final isSelected =
              state.selectedPackage?.identifier == package.identifier;
          final isBestValue =
              index == state.mainPackages.length - 1 &&
              state.mainPackages.length > 1;
          final (title, desc) = ProductNameResolver.resolve(package, l10n);

          return Padding(
            padding: EdgeInsets.only(
              bottom: index < state.mainPackages.length - 1 ? 10 : 0,
            ),
            child: GestureDetector(
              onTap: () => notifier.selectPackage(package),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.03)
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title.toUpperCase(),
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: colorScheme.onSurface,
                                  letterSpacing: -0.2,
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
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    if (isBestValue)
                      Positioned(
                        top: -10,
                        right: -8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            l10n.bestValue.toUpperCase(),
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onTertiary,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMainCTA(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
    PaywallState state,
    PaywallStateNotifier notifier,
    bool isSubscribed,
    bool isLifetime,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isLifetime
              ? () => Navigator.maybePop(context)
              : (state.isLoading || state.selectedPackage == null
                    ? null
                    : () => _handlePurchase(
                        notifier,
                        'main_paywall',
                        isSubscribed,
                      )),
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
                  (isLifetime ? l10n.close : l10n.getJobHunterPassNow)
                      .toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDownsell(PaywallState state, PaywallStateNotifier notifier) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final downsell = state.downsellPackage!;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(colorScheme),
          const SizedBox(height: 8),
          _buildDownsellHeadline(l10n, colorScheme, textTheme),
          const SizedBox(height: 16),
          _buildDownsellPricingCard(downsell, colorScheme, textTheme),
          const SizedBox(height: 16),
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
      ),
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
              Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.paywallSimpleBenefit,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDownsellPricingCard(
    Package package,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final (title, desc) = ProductNameResolver.resolve(package, l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.primary, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.2,
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
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
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
                  await _handlePurchase(notifier, 'downsell', false);
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
      padding: const EdgeInsets.only(top: 10, bottom: 8),
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
      onTap: () => Navigator.maybePop(context),
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
