import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cv_generation_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobTailoringBottomSheet extends ConsumerWidget {
  const JobTailoringBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const JobTailoringBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tailoringOptions = ref.watch(cvCreationProvider).tailoringOptions;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: colorScheme.surface,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.aiTailoringOptions,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      // Optional: if a subtitle exists in localization, use it. Otherwise, omit.
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _SkillLimitSlider(
                  value: tailoringOptions.maxSkills,
                  onChanged: (val) => ref
                      .read(cvCreationProvider.notifier)
                      .setTailoringOptions(
                        tailoringOptions.copyWith(maxSkills: val),
                      ),
                ),
                const SizedBox(height: 24),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                ),
                const SizedBox(height: 20),
                _OptionSwitch(
                  title: l10n.honestAiFeedback,
                  subtitle: l10n.honestAiFeedbackDesc,
                  value: tailoringOptions.strictMode,
                  onChanged: (val) => ref
                      .read(cvCreationProvider.notifier)
                      .setTailoringOptions(
                        tailoringOptions.copyWith(strictMode: val),
                      ),
                ),
                const SizedBox(height: 20),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                ),
                const SizedBox(height: 20),
                _OptionSwitch(
                  title: l10n.conciseFormat,
                  subtitle: l10n.conciseFormatDesc,
                  value: tailoringOptions.conciseMode,
                  onChanged: (val) => ref
                      .read(cvCreationProvider.notifier)
                      .setTailoringOptions(
                        tailoringOptions.copyWith(conciseMode: val),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillLimitSlider extends StatelessWidget {
  final int value;
  final Function(int) onChanged;

  const _SkillLimitSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.maxSkills,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$value',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.surface,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colorScheme.onSurface,
            inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.1),
            thumbColor: colorScheme.onSurface,
            overlayColor: colorScheme.onSurface.withValues(alpha: 0.08),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 5,
            max: 20,
            divisions: 15,
            onChanged: (val) => onChanged(val.round()),
          ),
        ),
      ],
    );
  }
}

class _OptionSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _OptionSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: colorScheme.surface,
          activeTrackColor: colorScheme.onSurface,
          inactiveThumbColor: colorScheme.onSurface.withValues(alpha: 0.4),
          inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}
