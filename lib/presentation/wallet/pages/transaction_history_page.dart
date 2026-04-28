import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:clever/core/theme/app_colors.dart';
import '../providers/transaction_provider.dart';
import '../../../domain/entities/wallet_transaction.dart';

class TransactionHistoryPage extends ConsumerStatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  ConsumerState<TransactionHistoryPage> createState() =>
      _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends ConsumerState<TransactionHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                    color: Colors.black,
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.transactionHistory.toUpperCase(),
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // --- TAB BAR SECTION ---
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: colorScheme.surface,
                unselectedLabelColor: colorScheme.onSurface.withValues(
                  alpha: 0.4,
                ),
                labelStyle: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
                unselectedLabelStyle: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  Tab(text: l10n.exports.toUpperCase()),
                  Tab(text: l10n.topUps.toUpperCase()),
                ],
              ),
            ),
          ),
          Expanded(
            child: transactionAsync.when(
              data: (transactions) {
                final exports = transactions
                    .where((t) => t.type == 'credit_deduct')
                    .toList();
                final topUps = transactions
                    .where((t) => t.type == 'credit_add')
                    .toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTransactionList(
                      exports,
                      l10n,
                      colorScheme,
                      textTheme,
                    ),
                    _buildTransactionList(topUps, l10n, colorScheme, textTheme),
                  ],
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

  Widget _buildTransactionList(
    List<WalletTransaction> items,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (items.isEmpty) {
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

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(
        color: colorScheme.onSurface.withValues(alpha: 0.03),
        height: 48,
      ),
      itemBuilder: (context, index) {
        final txn = items[index];
        final isAdd = txn.isAddition;

        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAdd
                    ? Colors.green.withValues(alpha: 0.1)
                    : colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isAdd ? Icons.add_rounded : Icons.file_upload_outlined,
                color: isAdd ? Colors.green : colorScheme.onSurface,
                size: 20,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAdd
                        ? l10n.topUp.toUpperCase()
                        : l10n.cvExport.toUpperCase(),
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                      letterSpacing: 0.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(txn.timestamp),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
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
                  '${isAdd ? '+' : '-'}${txn.amount}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isAdd ? Colors.green : colorScheme.onSurface,
                  ),
                ),
                Text(
                  l10n.credits.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
