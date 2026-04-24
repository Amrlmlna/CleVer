import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cv_generation_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobTailoringOptionsSection extends ConsumerStatefulWidget {
  const JobTailoringOptionsSection({super.key});

  @override
  ConsumerState<JobTailoringOptionsSection> createState() =>
      _JobTailoringOptionsSectionState();
}

class _JobTailoringOptionsSectionState
    extends ConsumerState<JobTailoringOptionsSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tailoringOptions = ref.watch(cvCreationProvider).tailoringOptions;
    final l10n = AppLocalizations.of(context)!;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: colorScheme.primary,
          collapsedIconColor: colorScheme.primary.withValues(alpha: 0.7),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.05),
          ),
        ),
        child: ExpansionTile(
          onExpansionChanged: (val) => setState(() => _isExpanded = val),
          trailing: AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: _isExpanded ? 0.5 : 0,
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.primary,
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.tune_rounded,
                size: 18,
                color: colorScheme.primary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.aiTailoringOptions,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.9),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1, thickness: 0.5),
                    ),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1, thickness: 0.5),
                    ),
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
            ),
          ],
        ),
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.maxSkills,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$value',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor: colorScheme.primary.withValues(alpha: 0.1),
            thumbColor: colorScheme.primary,
            overlayColor: colorScheme.primary.withValues(alpha: 0.1),
            trackHeight: 4,
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

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      value: value,
      activeThumbColor: colorScheme.primary,
      onChanged: onChanged,
    );
  }
}
