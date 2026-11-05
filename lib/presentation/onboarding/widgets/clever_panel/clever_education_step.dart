import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common/widgets/clever/clever_confirm_sheet.dart';
import '../../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../../profile/widgets/education_bottom_sheet.dart';
import '../../../../domain/entities/education.dart';
import '../../providers/onboarding_provider.dart';
import 'clever_list_step_widgets.dart';

/// Panel page 3 — education. Same list/dynamic-label pattern as experience.
class CleverEducationStep extends ConsumerWidget {
  const CleverEducationStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final education = ref.watch(
      onboardingFormProvider.select((s) => s.formData.education),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 33, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.educationTitle,
            style: CleverTypography.h1.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space8),
          Text(
            l10n.cleverEducationSubtitle,
            style: CleverTypography.body.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space24),
          CleverListHeader(onAdd: () => _addEducation(context, education, ref)),
          const SizedBox(height: CleverSpacing.space32),
          Expanded(
            child: education.isEmpty
                ? CleverListEmptyState(
                    illustration: 'assets/images/EmptyStateImage.svg',
                    prompt: l10n.cleverEmptyEducationPrompt,
                    onTap: () => _addEducation(context, education, ref),
                  )
                : CleverEntryList(
                    itemCount: education.length,
                    rowBuilder: (index) {
                      final edu = education[index];
                      return CleverEntryRow(
                        title: edu.schoolName,
                        metaTop: edu.degree,
                        metaBottom:
                            '${edu.startDate} - ${edu.endDate ?? l10n.present}',
                        onTap: () =>
                            _editEducation(context, ref, education, index, edu),
                        onLongPress: () => _deleteEducation(
                          context,
                          ref,
                          education,
                          index,
                          edu.schoolName,
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: CleverSpacing.space16),
          CleverNavActionBar(
            tone: CleverNavTone.orange,
            onBack: () => ref.read(onboardingFormProvider.notifier).prevPage(),
            nextLabel: education.isEmpty ? l10n.cleverSkip : l10n.next,
            onNext: onNext,
          ),
        ],
      ),
    );
  }

  Future<void> _addEducation(
    BuildContext context,
    List<Education> education,
    WidgetRef ref,
  ) => _editEducation(context, ref, education, null, null);

  Future<void> _editEducation(
    BuildContext context,
    WidgetRef ref,
    List<Education> education,
    int? index,
    Education? existing,
  ) async {
    final result = await EducationBottomSheet.show(context, existing: existing);
    if (result == null || !context.mounted) return;

    final notifier = ref.read(onboardingFormProvider.notifier);
    final updated = [...education];

    if (index == null) {
      // Legacy parity: warn instead of adding an identical entry.
      final isDuplicate = updated.any(
        (edu) =>
            edu.schoolName.toLowerCase() == result.schoolName.toLowerCase() &&
            edu.degree.toLowerCase() == result.degree.toLowerCase() &&
            edu.startDate == result.startDate,
      );
      if (isDuplicate) {
        CustomSnackBar.showWarning(
          context,
          AppLocalizations.of(context)!.cvDataExists,
        );
        return;
      }
      updated.add(result);
    } else {
      updated[index] = result;
    }
    notifier.updateEducation(updated);
  }

  Future<void> _deleteEducation(
    BuildContext context,
    WidgetRef ref,
    List<Education> education,
    int index,
    String title,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await CleverConfirmSheet.show(
      context,
      title: l10n.cleverDeleteEducationTitle,
      message: title,
      confirmLabel: l10n.cleverConfirmDelete,
      discardLabel: l10n.cancel,
    );
    if (confirmed != true || !context.mounted) return;

    final updated = [...education]..removeAt(index);
    ref.read(onboardingFormProvider.notifier).updateEducation(updated);
  }
}
