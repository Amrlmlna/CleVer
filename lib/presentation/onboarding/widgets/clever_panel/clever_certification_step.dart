import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../domain/entities/certification.dart';
import '../../../common/widgets/clever/clever_confirm_sheet.dart';
import '../../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../../profile/widgets/certification_bottom_sheet.dart';
import '../../providers/onboarding_provider.dart';
import 'clever_list_step_widgets.dart';

/// Panel page 4 — certifications. List/empty/dynamic-label pattern.
class CleverCertificationStep extends ConsumerWidget {
  const CleverCertificationStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final certifications = ref.watch(
      onboardingFormProvider.select((s) => s.formData.certifications),
    );
    final dateFormat = DateFormat('MMM yyyy');

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 33, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CleverListHeader(
            onAdd: () => _addCertification(context, certifications, ref),
          ),
          const SizedBox(height: CleverSpacing.space24),
          Text(
            l10n.certificationTitle,
            style: CleverTypography.h1.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space8),
          Text(
            l10n.cleverCertificationSubtitle,
            style: CleverTypography.body.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          Expanded(
            child: certifications.isEmpty
                ? CleverListEmptyState(
                    illustration: 'assets/images/EmptyStateImage.svg',
                    prompt: l10n.cleverEmptyCertificationPrompt,
                    onTap: () =>
                        _addCertification(context, certifications, ref),
                  )
                : CleverEntryList(
                    itemCount: certifications.length,
                    rowBuilder: (index) {
                      final cert = certifications[index];
                      return CleverEntryRow(
                        title: cert.name,
                        metaTop: dateFormat.format(cert.date),
                        metaBottom: cert.issuer,
                        onTap: () => _editCertification(
                          context,
                          ref,
                          certifications,
                          index,
                          cert,
                        ),
                        onLongPress: () => _deleteCertification(
                          context,
                          ref,
                          certifications,
                          index,
                          cert.name,
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: CleverSpacing.space16),
          CleverNavActionBar(
            tone: CleverNavTone.orange,
            onBack: () => ref.read(onboardingFormProvider.notifier).prevPage(),
            nextLabel: certifications.isEmpty ? l10n.cleverSkip : l10n.next,
            onNext: onNext,
          ),
        ],
      ),
    );
  }

  Future<void> _addCertification(
    BuildContext context,
    List<Certification> certifications,
    WidgetRef ref,
  ) => _editCertification(context, ref, certifications, null, null);

  Future<void> _editCertification(
    BuildContext context,
    WidgetRef ref,
    List<Certification> certifications,
    int? index,
    Certification? existing,
  ) async {
    final result = await CertificationBottomSheet.show(
      context,
      existing: existing,
    );
    if (result == null || !context.mounted) return;

    final notifier = ref.read(onboardingFormProvider.notifier);
    final updated = [...certifications];

    if (index == null) {
      // Legacy parity: warn instead of adding an identical entry.
      final isDuplicate = updated.any(
        (cert) =>
            cert.name.toLowerCase() == result.name.toLowerCase() &&
            cert.issuer.toLowerCase() == result.issuer.toLowerCase(),
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
    notifier.updateCertifications(updated);
  }

  Future<void> _deleteCertification(
    BuildContext context,
    WidgetRef ref,
    List<Certification> certifications,
    int index,
    String title,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await CleverConfirmSheet.show(
      context,
      title: l10n.cleverDeleteCertificationTitle,
      message: title,
      confirmLabel: l10n.cleverConfirmDelete,
      discardLabel: l10n.cancel,
    );
    if (confirmed != true || !context.mounted) return;

    final updated = [...certifications]..removeAt(index);
    ref.read(onboardingFormProvider.notifier).updateCertifications(updated);
  }
}
