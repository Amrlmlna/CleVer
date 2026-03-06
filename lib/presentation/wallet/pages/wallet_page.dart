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
import 'package:google_fonts/google_fonts.dart';
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
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/wallet/history'),
                    icon: Icon(
                      Icons.history_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Premium Wallet Card
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

              // Buy Credit Section
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

              // History Placeholder
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.recentTransactions,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/wallet/history'),
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
              // Transaction List
              transactionAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 48,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noTransactionsYet,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.4),
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
                        color: Colors.white.withValues(alpha: 0.05),
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
                                  : Colors.red.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isAdd
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              color: isAdd ? Colors.green : Colors.red,
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
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'MMM d, yyyy • h:mm a',
                                  ).format(txn.timestamp),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${isAdd ? '+' : '-'}${txn.amount}',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isAdd ? Colors.green : Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: Colors.amber),
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
