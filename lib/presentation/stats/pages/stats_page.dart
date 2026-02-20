import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/user_level_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/user_level_card.dart';
import '../widgets/activity_chart.dart';
import '../widgets/stats_grid.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLevelKey = ref.watch(userLevelProvider);
    final stats = ref.watch(profileStatsProvider);
    final weeklyActivity = ref.watch(weeklyActivityProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    String getLocalizedLevel(String key) {
      final l10n = AppLocalizations.of(context)!;
      switch (key) {
        case 'userLevelRookie': return l10n.userLevelRookie;
        case 'userLevelMid': return l10n.userLevelMid;
        case 'userLevelExpert': return l10n.userLevelExpert;
        default: return key;
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.careerAnalytics),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserLevelCard(level: getLocalizedLevel(userLevelKey), isDark: isDark)
                .animate()
                .fadeIn(duration: 600.ms, curve: Curves.easeOutQuad)
                .slideX(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOutQuad),

            const SizedBox(height: 24),

            Text(
              AppLocalizations.of(context)!.activityOverview,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 500.ms)
                .slideX(begin: -0.1, end: 0),

            const SizedBox(height: 16),
            ActivityChart(isDark: isDark, weeklyActivity: weeklyActivity)
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms)
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.easeOutBack),
            const SizedBox(height: 24),

            Text(
              AppLocalizations.of(context)!.keyMetrics,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 500.ms)
                .slideX(begin: -0.1, end: 0),

            const SizedBox(height: 16),
            StatsGrid(stats: stats, isDark: isDark)
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
          ],
        ),
      ),
    );
  }
}
