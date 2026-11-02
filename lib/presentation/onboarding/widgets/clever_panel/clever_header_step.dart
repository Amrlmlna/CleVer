import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common/widgets/clever/clever_gender_chips.dart';
import '../../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../../common/widgets/clever/clever_text_field.dart';
import '../../providers/onboarding_provider.dart';

/// Panel page 0 — personal data ("header") on the orange career-bank sheet.
/// Writes straight into [onboardingFormProvider] (which persists the draft),
/// so the existing submit flow stores it unchanged. The header cannot be
/// skipped: the button is always "lanjut" and requires a name.
class CleverHeaderStep extends ConsumerStatefulWidget {
  const CleverHeaderStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  ConsumerState<CleverHeaderStep> createState() => _CleverHeaderStepState();
}

class _CleverHeaderStepState extends ConsumerState<CleverHeaderStep> {
  late final _name = TextEditingController();
  late final _email = TextEditingController();
  late final _phone = TextEditingController();
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(onboardingFormProvider).formData;
    _name.text = existing.fullName;
    _email.text = existing.email;
    _phone.text = existing.phoneNumber ?? '';
    _birthDate = DateTime.tryParse(existing.birthDate ?? '');
    _prefillFromAuth();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _prefillFromAuth() {
    if (Firebase.apps.isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (_name.text.isEmpty && (user.displayName?.isNotEmpty ?? false)) {
      _name.text = user.displayName!;
    }
    if (_email.text.isEmpty && (user.email?.isNotEmpty ?? false)) {
      _email.text = user.email!;
    }
  }

  void _submit() {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.fillNameError,
            style: CleverTypography.body.copyWith(
              color: CleverColors.textOnDark,
            ),
          ),
          backgroundColor: CleverColors.bgDanger,
        ),
      );
      return;
    }
    // Legacy parity: the auth-prefilled email must reach the provider even
    // when the user never edits the field (the legacy controller listeners
    // did this on prefill).
    ref.read(onboardingFormProvider.notifier).updateEmail(_email.text);
    ref.read(onboardingFormProvider.notifier).updateName(_name.text);
    widget.onNext();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 20),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() => _birthDate = picked);
    ref
        .read(onboardingFormProvider.notifier)
        .updateBirthDate(picked.toIso8601String());
  }

  int? get _age {
    final birthDate = _birthDate;
    if (birthDate == null) return null;
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gender = ref.watch(
      onboardingFormProvider.select((s) => s.formData.gender),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 33, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.cleverPanelHeaderTitle,
            style: CleverTypography.h2.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space16),
          Text(
            l10n.cleverPanelHeaderSubtitle,
            style: CleverTypography.bodyStrong.copyWith(
              color: CleverColors.textOnInverse,
            ),
          ),
          const SizedBox(height: CleverSpacing.space24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Field(
                    controller: _name,
                    hint: l10n.fullName,
                    icon: Icons.person_outline,
                    onChanged: (text) => ref
                        .read(onboardingFormProvider.notifier)
                        .updateName(text),
                  ),
                  const SizedBox(height: CleverSpacing.space24),
                  _Field(
                    controller: _phone,
                    hint: l10n.cleverPhoneField,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    onChanged: (text) => ref
                        .read(onboardingFormProvider.notifier)
                        .updatePhone(text),
                  ),
                  const SizedBox(height: CleverSpacing.space24),
                  _Field(
                    controller: _email,
                    hint: l10n.email,
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) => ref
                        .read(onboardingFormProvider.notifier)
                        .updateEmail(text),
                  ),
                  const SizedBox(height: CleverSpacing.space32),
                  _LabeledField(
                    label: l10n.birthDate,
                    tooltip: l10n.cleverTooltipBirthDate,
                    child: _BirthDateField(
                      label: _birthDate == null
                          ? l10n.selectDate
                          : DateFormat.yMMMMd(
                              Localizations.localeOf(context).languageCode,
                            ).format(_birthDate!),
                      hasValue: _birthDate != null,
                      age: _age,
                      onTap: _pickBirthDate,
                    ),
                  ),
                  const SizedBox(height: CleverSpacing.space32),
                  _LabeledField(
                    label: l10n.gender,
                    tooltip: l10n.cleverTooltipGender,
                    child: CleverGenderChips(
                      selected: gender,
                      onSelect: (value) => ref
                          .read(onboardingFormProvider.notifier)
                          .updateGender(value),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: CleverSpacing.space16),
          CleverNavActionBar(
            tone: CleverNavTone.cream,
            nextLabel: l10n.next,
            onNext: _submit,
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CleverTextField(
      controller: controller,
      hintText: hint,
      keyboardType: keyboardType,
      surface: CleverFieldSurface.filledOnAction,
      prefixIcon: icon,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.tooltip,
    required this.child,
  });

  final String label;
  final String tooltip;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: CleverTypography.body.copyWith(
                color: CleverColors.textOnInverse,
              ),
            ),
            const SizedBox(width: 6),
            Tooltip(
              message: tooltip,
              triggerMode: TooltipTriggerMode.longPress,
              textStyle: CleverTypography.bodySm.copyWith(
                color: CleverColors.textOnDark,
              ),
              decoration: BoxDecoration(
                color: CleverColors.surfaceInverse,
                borderRadius: BorderRadius.circular(CleverRadius.field),
              ),
              child: const Icon(
                Icons.info_outline,
                size: 17,
                color: CleverColors.textOnInverse,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _BirthDateField extends StatelessWidget {
  const _BirthDateField({
    required this.label,
    required this.hasValue,
    required this.age,
    required this.onTap,
  });

  final String label;
  final bool hasValue;
  final int? age;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final valueColor = hasValue
        ? CleverColors.textOnInverse
        : CleverColors.textOnInverse.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CleverRadius.button),
      child: Container(
        height: CleverSizes.field,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: CleverColors.surfaceFieldOnAction,
          borderRadius: BorderRadius.circular(CleverRadius.button),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 19,
              color: CleverColors.textOnInverse,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: CleverTypography.bodyStrong.copyWith(color: valueColor),
              ),
            ),
            if (age != null) ...[
              Container(
                width: CleverStrokes.hairline,
                height: 20,
                color: CleverColors.textOnInverse.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.cleverYearsOld(age!),
                style: CleverTypography.bodySm.copyWith(
                  color: CleverColors.textOnInverse,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
