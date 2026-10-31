import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../../profile/widgets/experience_bottom_sheet.dart';
import '../../../profile/widgets/experience_list_form.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../providers/onboarding_provider.dart';

/// Panel page 2 — work experience. Empty state per staging (briefcase
/// illustration + "masih kosong nih"); entries added through the existing
/// ExperienceBottomSheet flow. The nav label is dynamic: "lewati" while the
/// list is empty, "lanjut" once there is data.
class CleverExperienceStep extends ConsumerWidget {
  const CleverExperienceStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final experiences = ref.watch(
      onboardingFormProvider.select((s) => s.formData.experience),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 33, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ListHeader(
            onAdd: () => _addExperience(
              context,
              experiences,
              (value) => ref
                  .read(onboardingFormProvider.notifier)
                  .updateExperience(value),
            ),
          ),
          const SizedBox(height: CleverSpacing.space24),
          Text(
            l10n.experienceTitle,
            style: CleverTypography.h1.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space8),
          Text(
            l10n.cleverExperienceSubtitle,
            style: CleverTypography.body.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          Expanded(
            child: experiences.isEmpty
                ? _EmptyState(
                    illustration: 'assets/images/EmptyStateImage.svg',
                    prompt: l10n.cleverEmptyExperiencePrompt,
                    onTap: () => _addExperience(
                      context,
                      experiences,
                      (value) => ref
                          .read(onboardingFormProvider.notifier)
                          .updateExperience(value),
                    ),
                  )
                : SingleChildScrollView(
                    child: ExperienceListForm(
                      experiences: experiences,
                      onChanged: (value) => ref
                          .read(onboardingFormProvider.notifier)
                          .updateExperience(value),
                    ),
                  ),
          ),
          const SizedBox(height: CleverSpacing.space16),
          CleverNavActionBar(
            tone: CleverNavTone.orange,
            onBack: () => ref.read(onboardingFormProvider.notifier).prevPage(),
            nextLabel: experiences.isEmpty ? l10n.cleverSkip : l10n.next,
            onNext: onNext,
          ),
        ],
      ),
    );
  }

  Future<void> _addExperience(
    BuildContext context,
    List<Experience> experiences,
    ValueChanged<List<Experience>> onExperienceChanged,
  ) async {
    final result = await ExperienceBottomSheet.show(context);
    if (result == null || !context.mounted) return;

    // First entry from the empty state cannot duplicate anything.
    onExperienceChanged([...experiences, result]);
  }
}

/// "daftar" label + the round add button shared by every list step.
class _ListHeader extends StatelessWidget {
  const _ListHeader({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Text(
          l10n.cleverListLabel,
          style: CleverTypography.h3.copyWith(
            color: CleverColors.textOnInverse,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(CleverRadius.field),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: CleverColors.bgCanvas,
              borderRadius: BorderRadius.circular(CleverRadius.field),
            ),
            child: const Icon(
              Icons.add,
              size: 24,
              color: CleverColors.surfaceInverse,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.illustration,
    required this.prompt,
    required this.onTap,
  });

  final String illustration;
  final String prompt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(illustration, width: 229),
          const SizedBox(height: CleverSpacing.space24),
          Text(
            l10n.cleverEmptyTitle,
            style: CleverTypography.h2.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space8),
          GestureDetector(
            onTap: onTap,
            child: Text(
              prompt,
              style: CleverTypography.bodySm.copyWith(
                color: CleverColors.textOnInverse.withValues(alpha: 0.62),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
