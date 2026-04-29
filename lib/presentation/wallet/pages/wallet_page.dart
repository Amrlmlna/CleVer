import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../templates/providers/template_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../widgets/wallet_card.dart';
import '../providers/transaction_provider.dart';
import '../../../core/services/payment_service.dart';
import '../../auth/utils/auth_guard.dart';
import '../../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);
    final profile = ref.watch(masterProfileProvider);
    final transactionAsync = ref.watch(transactionHistoryProvider);
    final cardHolder = profile?.fullName.toUpperCase() ?? "CLEVER MEMBER";
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- TOP ACCENT SECTION ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accentPeach,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(48),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(32, 80, 32, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.wallet,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          fontSize: 32,
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push('/wallet/history'),
                        icon: const Icon(
                          Icons.history_rounded,
                          color: Colors.black,
                          size: 24,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  templatesAsync.when(
                    data: (templates) {
                      final totalCredits = templates.isNotEmpty
                          ? templates.first.userCredits
                          : 0;
                      return WalletCard(
                        totalCredits: totalCredits,
                        cardHolder: cardHolder,
                        onTopUp: AuthGuard.protected(
                          context,
                          () async {
                            final purchased =
                                await PaymentService.presentPaywall(context);
                            if (purchased) {
                              ref.invalidate(templatesProvider);
                            }
                          },
                          featureTitle: l10n.authWallBuyCredits,
                          featureDescription: l10n.authWallBuyCreditsDesc,
                        ),
                      );
                    },
                    loading: () => WalletCard(
                      totalCredits: 0,
                      cardHolder: cardHolder,
                      isLoading: true,
                    ),
                    error: (error, stack) =>
                        WalletCard(totalCredits: 0, cardHolder: cardHolder),
                  ),
                ],
              ),
            ),

            // --- BOTTOM LIST SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.recentTransactions.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          letterSpacing: 1.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/wallet/history'),
                        child: Text(
                          l10n.viewAll.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  transactionAsync.when(
                    data: (transactions) {
                      if (transactions.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_rounded,
                                size: 40,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noTransactionsYet.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.3,
                                  ),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final latestTransactions = transactions.take(5).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: latestTransactions.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final txn = latestTransactions[index];
                          final isAdd = txn.isAddition;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: InkWell(
                              onTap: () => context.push('/wallet/history'),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.03,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: colorScheme.onSurface,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Icon(
                                        isAdd
                                            ? Icons.add_rounded
                                            : Icons.file_upload_outlined,
                                        color: colorScheme.surface,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (txn.type == 'credit_add'
                                                    ? l10n.topUp
                                                    : l10n.cvExport)
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 15,
                                              color: colorScheme.onSurface,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            DateFormat(
                                              'MMM d, h:mm a',
                                            ).format(txn.timestamp),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurface
                                                  .withValues(alpha: 0.4),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${isAdd ? '+' : '-'}${txn.amount} ${l10n.credits.toUpperCase()}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                              color: colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: colorScheme.onSurface.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.chevron_right_rounded,
                                        color: colorScheme.onSurface,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          l10n.failedToLoadTransactions.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
