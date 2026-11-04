import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../providers/onboarding_provider.dart';

/// Panel page 6 — completion summary per staging: success badge, "semua
/// siap!", live profile summary rows, and the exit nav.
class CleverCompleteStep extends ConsumerWidget {
  const CleverCompleteStep({super.key, required this.onFinish});

  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final formData = ref.watch(
      onboardingFormProvider.select((s) => s.formData),
    );

    final filled = [
      formData.fullName.isNotEmpty,
      formData.experience.isNotEmpty,
      formData.education.isNotEmpty,
      formData.certifications.isNotEmpty,
      formData.skills.isNotEmpty,
    ];
    final completed = filled.where((f) => f).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 33, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Everything but the nav bar scrolls: the badge + title + subtitle
          // + header + five summary rows total ~694px of fixed height, which
          // overflowed short devices (~670px) by 23px.
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: CleverSpacing.space24),
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CleverColors.bgCanvas,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 34,
                        color: CleverColors.bgAction,
                      ),
                    ),
                  ),
                  const SizedBox(height: CleverSpacing.space24),
                  Text(
                    l10n.cleverCompleteTitle,
                    textAlign: TextAlign.center,
                    style: CleverTypography.h1.copyWith(
                      color: CleverColors.textOnInverse,
                    ),
                  ),
                  const SizedBox(height: CleverSpacing.space8),
                  Text(
                    l10n.cleverCompleteSubtitle,
                    textAlign: TextAlign.center,
                    style: CleverTypography.body.copyWith(
                      color: CleverColors.textOnInverse.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: CleverSpacing.space24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.cleverCompleteSummary,
                          style: CleverTypography.h4.copyWith(
                            color: CleverColors.textOnInverse,
                          ),
                        ),
                      ),
                      Text(
                        '$completed dari 5',
                        style: CleverTypography.body.copyWith(
                          color: CleverColors.textOnInverse
                              .withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: CleverSpacing.space16),
                  _SummaryRow(
                    label: l10n.cleverCompleteRowHeader,
                    detail: formData.fullName,
                    done: filled[0],
                  ),
                  _SummaryRow(
                    label: l10n.experienceTitle,
                    detail: l10n.cleverCompleteCount(
                      formData.experience.length,
                    ),
                    done: filled[1],
                  ),
                  _SummaryRow(
                    label: l10n.educationTitle,
                    detail: l10n.cleverCompleteCount(formData.education.length),
                    done: filled[2],
                  ),
                  _SummaryRow(
                    label: l10n.certificationTitle,
                    detail: l10n.cleverCompleteCount(
                      formData.certifications.length,
                    ),
                    done: filled[3],
                  ),
                  _SummaryRow(
                    label: l10n.skillsTitle,
                    detail: l10n.cleverCompleteCount(formData.skills.length),
                    done: filled[4],
                  ),
                ],
              ),
            ),
          ),
          Text(
            l10n.cleverCompleteFootnote,
            textAlign: TextAlign.center,
            style: CleverTypography.bodySm.copyWith(
              color: CleverColors.textOnInverse.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: CleverSpacing.space16),
          CleverNavActionBar(
            tone: CleverNavTone.orange,
            nextLabel: l10n.startNow,
            onNext: onFinish,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.detail,
    required this.done,
  });

  final String label;
  final String detail;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CleverSpacing.space12),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: CleverColors.bgCanvas,
          borderRadius: BorderRadius.circular(CleverRadius.button),
        ),
        child: Row(
          children: [
            Icon(
              done ? Icons.check : Icons.do_not_disturb_on,
              size: 21,
              color: CleverColors.bgAction,
            ),
            const SizedBox(width: CleverSpacing.space12),
            Expanded(
              child: Text(
                label,
                style: CleverTypography.bodyStrong.copyWith(
                  color: CleverColors.textPrimary,
                ),
              ),
            ),
            Flexible(
              child: Text(
                detail.isEmpty ? '-' : detail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CleverTypography.caption.copyWith(
                  color: CleverColors.textPrimary.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
