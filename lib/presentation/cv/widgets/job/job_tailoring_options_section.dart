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
    final textTheme = Theme.of(context).textTheme;
    final tailoringOptions = ref.watch(cvCreationProvider).tailoringOptions;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          // ─── Toggle Header ──────────────────────────────────────
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: _isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 16,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.aiTailoringOptions.toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface.withValues(alpha: 0.35),
                        letterSpacing: 1.5,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 250),
                    turns: _isExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Expandable Content ─────────────────────────────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.onSurface.withValues(alpha: 0.06),
                  indent: 16,
                  endIndent: 16,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
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
                      const SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: colorScheme.onSurface.withValues(alpha: 0.06),
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
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: colorScheme.onSurface.withValues(alpha: 0.06),
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
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$value',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.surface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colorScheme.onSurface,
            inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.1),
            thumbColor: colorScheme.onSurface,
            overlayColor: colorScheme.onSurface.withValues(alpha: 0.08),
            trackHeight: 3,
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

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        title,
        style: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.4),
          fontSize: 10,
        ),
      ),
      value: value,
      activeTrackColor: colorScheme.onSurface,
      activeThumbColor: colorScheme.surface,
      inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.1),
      onChanged: onChanged,
    );
  }
}
