import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:clever/core/theme/app_colors.dart';
import 'package:clever/core/utils/subscription_formatter.dart';
import '../providers/transaction_provider.dart';
import '../widgets/subscription_paywall.dart';
import '../../templates/providers/template_provider.dart';

class TransactionHistoryPage extends ConsumerStatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  ConsumerState<TransactionHistoryPage> createState() =>
      _TransactionHistoryPageState();
}

class _TransactionHistoryPageState
    extends ConsumerState<TransactionHistoryPage> {
  @override
  Widget build(BuildContext context) {
    final transactionAsync = ref.watch(transactionHistoryProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // --- TOP ACCENT HEADER ---
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.accentPeach,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(48),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.accentPeachDark,
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.accentPeachDark.withValues(
                      alpha: 0.1,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.transactionHistory.toUpperCase(),
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.accentPeachDark,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: transactionAsync.when(
              data: (transactions) {
                // Prioritize subscription related transactions
                final sortedTxns = [...transactions];
                sortedTxns.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                if (sortedTxns.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 48,
                          color: colorScheme.onSurface.withValues(alpha: 0.05),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noTransactionsYet,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(transactionHistoryProvider);
                    ref.invalidate(templatesProvider);
                  },
                  child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  itemCount: sortedTxns.length,
                  separatorBuilder: (_, __) => Divider(
                    color: colorScheme.onSurface.withValues(alpha: 0.03),
                    height: 48,
                  ),
                  itemBuilder: (context, index) {
                    final txn = sortedTxns[index];
                    final isAdd = txn.isAddition;
                    final isSubUpdate = txn.type == 'subscription_update';

                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isAdd
                                ? colorScheme.primary.withValues(alpha: 0.1)
                                : colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            isSubUpdate
                                ? Icons.verified_user_rounded
                                : (isAdd
                                      ? Icons.add_rounded
                                      : Icons.file_upload_outlined),
                            color: isAdd
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (isSubUpdate
                                        ? SubscriptionPaywall.getDisplayName(
                                            txn.productDisplayName, l10n)
                                        : (isAdd
                                              ? l10n.unlockFeatures
                                              : l10n.cvExport))
                                    .toUpperCase(),
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: colorScheme.onSurface,
                                  letterSpacing: 0.5,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat(
                                  'dd MMM yyyy, HH:mm',
                                ).format(txn.timestamp),
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              isSubUpdate
                                  ? SubscriptionFormatter.formatTransactionStatus(txn, l10n)
                                  : '${isAdd ? '+' : '-'}${txn.amount}',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: isAdd
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ),
                            ),
                            if (isSubUpdate)
                              Text(
                                l10n.added.toUpperCase(),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.3,
                                  ),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 9,
                                ),
                              )
                            else
                              Text(
                                l10n.cv.toUpperCase(),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.3,
                                  ),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 9,
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              ),
              error: (err, _) => Center(
                child: Text(
                  l10n.failedToLoadTransactions,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
