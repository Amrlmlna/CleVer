import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class ActivityChart extends StatelessWidget {
  final List<int> weeklyActivity;

  const ActivityChart({super.key, required this.weeklyActivity});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final maxY =
        (weeklyActivity.isNotEmpty
                ? weeklyActivity.reduce(
                    (curr, next) => curr > next ? curr : next,
                  )
                : 5)
            .toDouble();
    final effectiveMaxY = maxY < 5 ? 5.0 : maxY + 1;

    return Container(
      height: 220,
      padding: const EdgeInsets.only(right: 16, top: 24, bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: LineChart(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: colorScheme.outlineVariant, strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final titles = [
                    AppLocalizations.of(context)!.mon,
                    AppLocalizations.of(context)!.tue,
                    AppLocalizations.of(context)!.wed,
                    AppLocalizations.of(context)!.thu,
                    AppLocalizations.of(context)!.fri,
                    AppLocalizations.of(context)!.sat,
                    AppLocalizations.of(context)!.sun,
                  ];
                  final index = value.toInt();
                  if (index >= 0 && index < titles.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        titles[index],
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: effectiveMaxY,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(weeklyActivity.length, (index) {
                return FlSpot(
                  index.toDouble(),
                  weeklyActivity[index].toDouble(),
                );
              }),
              isCurved: true,
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.tertiary],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.2),
                    colorScheme.tertiary.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
