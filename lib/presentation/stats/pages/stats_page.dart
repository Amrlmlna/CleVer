import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/user_level_provider.dart';

import '../widgets/user_level_card.dart';
import '../widgets/activity_chart.dart';
import '../widgets/stats_grid.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLevel = ref.watch(userLevelProvider);
    final stats = ref.watch(profileStatsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Analytics'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. User Level Card
            UserLevelCard(level: userLevel, isDark: isDark),
            const SizedBox(height: 24),

            // 2. Activity Chart
            const Text(
              'Activity Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ActivityChart(isDark: isDark),
            const SizedBox(height: 24),

            // 3. Stats Grid
            const Text(
              'Key Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StatsGrid(stats: stats, isDark: isDark),
          ],
        ),
      ),
    );
  }
}
