import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common/widgets/clever/clever_confirm_sheet.dart';
import '../../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../../profile/widgets/experience_bottom_sheet.dart';
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
                : _EntryList(
                    experiences: experiences,
                    onEdit: (index, existing) async {
                      final result = await ExperienceBottomSheet.show(
                        context,
                        existing: existing,
                      );
                      if (result == null || !context.mounted) return;
                      final updated = [...experiences];
                      updated[index] = result;
                      ref
                          .read(onboardingFormProvider.notifier)
                          .updateExperience(updated);
                    },
                    onDelete: (index) async {
                      final l10n = AppLocalizations.of(context)!;
                      final confirmed = await CleverConfirmSheet.show(
                        context,
                        title: l10n.cleverDeleteExperienceTitle,
                        message: experiences[index].jobTitle,
                        confirmLabel: l10n.cleverConfirmDelete,
                        discardLabel: l10n.cancel,
                      );
                      if (confirmed != true || !context.mounted) return;
                      final updated = [...experiences]..removeAt(index);
                      ref
                          .read(onboardingFormProvider.notifier)
                          .updateExperience(updated);
                    },
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

    // Legacy parity: warn instead of adding an identical entry.
    final isDuplicate = experiences.any(
      (exp) =>
          exp.jobTitle.toLowerCase() == result.jobTitle.toLowerCase() &&
          exp.companyName.toLowerCase() == result.companyName.toLowerCase() &&
          exp.startDate == result.startDate,
    );
    if (isDuplicate) {
      CustomSnackBar.showWarning(
        context,
        AppLocalizations.of(context)!.cvDataExists,
      );
      return;
    }

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

/// Scrollable cream entry rows with a fade into the orange sheet at the
/// bottom, per the staging mask.
class _EntryList extends StatelessWidget {
  const _EntryList({
    required this.experiences,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Experience> experiences;
  final Future<void> Function(int index, Experience existing) onEdit;
  final Future<void> Function(int index) onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < experiences.length; i++) ...[
                  _EntryRow(
                    experience: experiences[i],
                    onTap: () => onEdit(i, experiences[i]),
                    onLongPress: () => onDelete(i),
                  ),
                  if (i != experiences.length - 1)
                    const SizedBox(height: CleverSpacing.space12),
                ],
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 48,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    CleverColors.bgAction.withValues(alpha: 0),
                    CleverColors.bgAction,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Cream row per the staging list: ↗ + role, right-aligned period/company.
class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.experience,
    required this.onTap,
    required this.onLongPress,
  });

  final Experience experience;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(CleverRadius.button),
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: CleverColors.bgCanvas,
            borderRadius: BorderRadius.circular(CleverRadius.button),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.north_east,
                size: 21,
                color: CleverColors.surfaceInverse,
              ),
              const SizedBox(width: CleverSpacing.space12),
              Expanded(
                child: Text(
                  experience.jobTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CleverTypography.bodyStrong.copyWith(
                    color: CleverColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: CleverSpacing.space8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    experience.startDate,
                    style: CleverTypography.micro.copyWith(
                      color: CleverColors.textPrimary,
                    ),
                  ),
                  Text(
                    experience.companyName,
                    style: CleverTypography.caption.copyWith(
                      color: CleverColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
