import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../templates/providers/template_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../home/widgets/premium_banner.dart';
import '../widgets/wallet_card.dart';
import '../providers/transaction_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.wallet,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/wallet/history'),
                    icon: Icon(
                      Icons.history_rounded,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.onSurface.withValues(
                        alpha: 0.1,
                      ),
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

              const SizedBox(height: 32),

              const PremiumBanner()
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.recentTransactions,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withValues(alpha: 0.95),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/wallet/history'),
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              transactionAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.onSurface.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 48,
                            color: colorScheme.onSurface.withValues(alpha: 0.1),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noTransactionsYet,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final latestTransactions = transactions.take(3).toList();

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: latestTransactions.length,
                    separatorBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        color: colorScheme.onSurface.withValues(alpha: 0.05),
                        height: 1,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final txn = latestTransactions[index];
                      final isAdd = txn.isAddition;

                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isAdd
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : colorScheme.error.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isAdd
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              color: isAdd ? Colors.green : colorScheme.error,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  txn.type == 'credit_add'
                                      ? l10n.topUp
                                      : l10n.cvExport,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'MMM d, yyyy • h:mm a',
                                  ).format(txn.timestamp),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${isAdd ? '+' : '-'}${txn.amount}',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isAdd
                                  ? Colors.green
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(l10n.failedToLoadTransactions),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
