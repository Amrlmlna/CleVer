import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../templates/providers/template_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../home/widgets/premium_banner.dart';
import '../widgets/wallet_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);
    final profile = ref.watch(masterProfileProvider);
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
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          color: Colors.blueAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.secure,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
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
              Text(
                l10n.recentTransactions,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
              const SizedBox(height: 16),
              Container(
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
                      l10n.usageHistoryComingSoon,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
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
