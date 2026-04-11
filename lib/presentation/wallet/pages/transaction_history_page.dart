import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
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
  final ScrollController _exportScrollController = ScrollController();
  final ScrollController _topUpScrollController = ScrollController();

  double _exportTopFade = 0.0;
  double _exportBottomFade = 0.0;
  double _topUpTopFade = 0.0;
  double _topUpBottomFade = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _exportScrollController.addListener(
      () => _updateFade(_exportScrollController, (t, b) {
        setState(() {
          _exportTopFade = t;
          _exportBottomFade = b;
        });
      }),
    );

    _topUpScrollController.addListener(
      () => _updateFade(_topUpScrollController, (t, b) {
        setState(() {
          _topUpTopFade = t;
          _topUpBottomFade = b;
        });
      }),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFade(
        _exportScrollController,
        (t, b) => setState(() {
          _exportTopFade = t;
          _exportBottomFade = b;
        }),
      );
      _updateFade(
        _topUpScrollController,
        (t, b) => setState(() {
          _topUpTopFade = t;
          _topUpBottomFade = b;
        }),
      );
    });
  }

  void _updateFade(
    ScrollController controller,
    Function(double, double) onUpdate,
  ) {
    if (!controller.hasClients) return;

    final pos = controller.position;
    double topFade = (pos.pixels / 20).clamp(0.0, 1.0);
    double bottomFade = ((pos.maxScrollExtent - pos.pixels) / 20).clamp(
      0.0,
      1.0,
    );

    onUpdate(topFade, bottomFade);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _exportScrollController.dispose();
    _topUpScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionAsync = ref.watch(transactionHistoryProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.onSurface.withValues(
                        alpha: 0.05,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    l10n.transactionHistory.toUpperCase(),
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colorScheme.onSurface.withValues(alpha: 0.05),
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: colorScheme.onSurface,
                  unselectedLabelColor: colorScheme.onSurfaceVariant,
                  labelStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  unselectedLabelStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  padding: const EdgeInsets.all(4),
                  tabs: [
                    Tab(text: l10n.exports.toUpperCase()),
                    Tab(text: l10n.topUps.toUpperCase()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                        _exportScrollController,
                        _exportTopFade,
                        _exportBottomFade,
                        l10n,
                        colorScheme,
                        textTheme,
                      ),
                      _buildTransactionList(
                        topUps,
                        _topUpScrollController,
                        _topUpTopFade,
                        _topUpBottomFade,
                        l10n,
                        colorScheme,
                        textTheme,
                      ),
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
      ),
    );
  }

  Widget _buildTransactionList(
    List<WalletTransaction> items,
    ScrollController controller,
    double topFade,
    double bottomFade,
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

    return Stack(
      children: [
        ListView.separated(
          controller: controller,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          itemCount: items.length,
          separatorBuilder: (_, __) => Divider(
            color: colorScheme.onSurface.withValues(alpha: 0.03),
            height: 32,
          ),
          itemBuilder: (context, index) {
            final txn = items[index];
            final isAdd = txn.isAddition;

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isAdd
                        ? Colors.green.withValues(alpha: 0.08)
                        : colorScheme.onSurface.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isAdd ? Icons.add_rounded : Icons.file_upload_outlined,
                    color: isAdd ? Colors.green : colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAdd ? l10n.topUp : l10n.cvExport,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat(
                          'MMMM d, yyyy • HH:mm',
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
                    color: isAdd ? Colors.green : colorScheme.onSurface,
                  ),
                ),
              ],
            );
          },
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 40,
          child: IgnorePointer(
            child: Opacity(
              opacity: topFade,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.surface,
                      colorScheme.surface.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 40,
          child: IgnorePointer(
            child: Opacity(
              opacity: bottomFade,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      colorScheme.surface,
                      colorScheme.surface.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
