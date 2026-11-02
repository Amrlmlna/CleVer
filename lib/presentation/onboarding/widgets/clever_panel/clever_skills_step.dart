import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../domain/entities/skill.dart';
import '../../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../../profile/widgets/skills_bottom_sheet.dart';
import '../../providers/onboarding_provider.dart';
import 'clever_list_step_widgets.dart';

/// Panel page 5 — skills. Removable chips per staging; add via the search
/// sheet (hardskill/softskill toggle + duplicate check). No dictate: the
/// legacy skills flow has none.
class CleverSkillsStep extends ConsumerWidget {
  const CleverSkillsStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final skills = ref.watch(
      onboardingFormProvider.select((s) => s.formData.skills),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 33, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CleverListHeader(onAdd: () => _addSkill(context, skills, ref)),
          const SizedBox(height: CleverSpacing.space24),
          Text(
            l10n.skillsTitle,
            style: CleverTypography.h1.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space8),
          Text(
            l10n.skillsSubtitle,
            style: CleverTypography.body.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          Expanded(
            child: skills.isEmpty
                ? CleverListEmptyState(
                    illustration: 'assets/images/EmptyStateImage.svg',
                    prompt: l10n.cleverEmptySkillsPrompt,
                    onTap: () => _addSkill(context, skills, ref),
                  )
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: CleverSpacing.space8,
                      runSpacing: CleverSpacing.space8,
                      children: [
                        for (final skill in skills)
                          _SkillChip(
                            label: skill.name,
                            onRemove: () {
                              final updated = [...skills]..remove(skill);
                              ref
                                  .read(onboardingFormProvider.notifier)
                                  .updateSkills(updated);
                            },
                          ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: CleverSpacing.space16),
          CleverNavActionBar(
            tone: CleverNavTone.orange,
            onBack: () => ref.read(onboardingFormProvider.notifier).prevPage(),
            nextLabel: skills.isEmpty ? l10n.cleverSkip : l10n.next,
            onNext: onNext,
          ),
        ],
      ),
    );
  }

  Future<void> _addSkill(
    BuildContext context,
    List<Skill> skills,
    WidgetRef ref,
  ) async {
    final result = await SkillsBottomSheet.show(context, skills);
    if (result == null || !context.mounted) return;

    // Legacy parity: SkillsBottomSheet validates duplicates already, but
    // guard again against case-only matches.
    final isDuplicate = skills.any(
      (s) => s.name.toLowerCase() == result.name.toLowerCase(),
    );
    if (isDuplicate) {
      CustomSnackBarHelper.showExists(context);
      return;
    }

    ref.read(onboardingFormProvider.notifier).updateSkills([...skills, result]);
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: CleverColors.surfaceField,
        borderRadius: BorderRadius.circular(CleverRadius.field),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: CleverTypography.micro.copyWith(
              color: CleverColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.cancel,
              size: 16,
              color: CleverColors.bgAction,
            ),
          ),
        ],
      ),
    );
  }
}

/// Legacy-parity snackbar shim.
class CustomSnackBarHelper {
  static void showExists(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.cvDataExists,
          style: CleverTypography.body.copyWith(color: CleverColors.textOnDark),
        ),
        backgroundColor: CleverColors.bgDanger,
      ),
    );
  }
}
