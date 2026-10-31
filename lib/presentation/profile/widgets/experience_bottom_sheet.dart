import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/user_profile.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../common/widgets/clever/clever_confirm_sheet.dart';
import '../../common/widgets/clever/clever_dictate_panel.dart';
import '../../common/widgets/clever/clever_form_toggle.dart';
import '../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../common/widgets/clever/clever_text_field.dart';
import '../../common/widgets/spinning_text_loader.dart';
import '../../cv/providers/cv_generation_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

/// Add/edit experience form — the Clever cream sheet with the ketik/dikte
/// toggle. Dictate reuses the speech + /cv/parse-entity machinery; the
/// manual (ketik) tab keeps the legacy fields until its restyle pass.
class ExperienceBottomSheet extends ConsumerStatefulWidget {
  final Experience? existing;

  const ExperienceBottomSheet({super.key, this.existing});

  static Future<Experience?> show(
    BuildContext context, {
    Experience? existing,
  }) {
    return showModalBottomSheet<Experience>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: CleverColors.bgCanvas,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ExperienceBottomSheet(existing: existing),
      ),
    );
  }

  @override
  ConsumerState<ExperienceBottomSheet> createState() =>
      _ExperienceBottomSheetState();
}

class _ExperienceBottomSheetState extends ConsumerState<ExperienceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;
  late TextEditingController _descCtrl;

  bool _isRewriting = false;
  bool _canPopNow = false;
  bool _isVoiceMode = true;

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _companyFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.jobTitle);
    _companyCtrl = TextEditingController(text: widget.existing?.companyName);
    _startCtrl = TextEditingController(text: widget.existing?.startDate);
    _endCtrl = TextEditingController(text: widget.existing?.endDate);
    _descCtrl = TextEditingController(text: widget.existing?.description);
    if (widget.existing != null) {
      _isVoiceMode = false; // default to manual form when editing
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _descCtrl.dispose();
    _titleFocus.dispose();
    _companyFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  bool get _isDirty {
    return _titleCtrl.text != (widget.existing?.jobTitle ?? '') ||
        _companyCtrl.text != (widget.existing?.companyName ?? '') ||
        _startCtrl.text != (widget.existing?.startDate ?? '') ||
        _endCtrl.text != (widget.existing?.endDate ?? '') ||
        _descCtrl.text != (widget.existing?.description ?? '');
  }

  void _handlePop() async {
    if (_canPopNow) return;

    if (!_isDirty) {
      setState(() => _canPopNow = true);
      Navigator.pop(context);
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final result = await CleverConfirmSheet.show(
      context,
      title: l10n.cleverConfirmTitle,
      message: l10n.cleverConfirmMessage,
      confirmLabel: l10n.save,
      discardLabel: l10n.cleverConfirmDiscard,
    );
    if (!mounted || result == null) return;

    if (result) {
      _save();
    } else {
      setState(() => _canPopNow = true);
      Navigator.pop(context);
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final exp = Experience(
        id:
            widget.existing?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        jobTitle: _titleCtrl.text,
        companyName: _companyCtrl.text,
        startDate: _startCtrl.text,
        endDate: _endCtrl.text.isEmpty ? null : _endCtrl.text,
        description: _descCtrl.text,
      );
      setState(() => _canPopNow = true);
      Navigator.pop(context, exp);
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = DateFormat('MMM yyyy').format(picked);
    }
  }

  Future<void> _rewriteDescription() async {
    if (_descCtrl.text.isEmpty) {
      CustomSnackBar.showWarning(
        context,
        AppLocalizations.of(context)!.fillDescriptionFirst,
      );
      return;
    }

    setState(() {
      _isRewriting = true;
    });

    try {
      final repository = ref.read(cvRepositoryProvider);
      final locale = ref.read(localeNotifierProvider);

      String? instruction;
      if (_titleCtrl.text.isNotEmpty || _companyCtrl.text.isNotEmpty) {
        instruction =
            "Rewrite this job description to be high-impact and professional for a ${_titleCtrl.text} role${_companyCtrl.text.isNotEmpty ? " at ${_companyCtrl.text}" : ""}. Use the Google XYZ formula (Accomplished X by Y doing Z) and strong action verbs.";
      }

      final newText = await repository.rewriteContent(
        _descCtrl.text,
        locale: locale.languageCode,
        instruction: instruction,
      );

      if (mounted) {
        setState(() {
          _descCtrl.text = newText;
          _isRewriting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRewriting = false);
        CustomSnackBar.showError(
          context,
          AppLocalizations.of(context)!.rewriteFailed('$e'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: _canPopNow,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handlePop();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(31, 16, 33, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CleverFormToggle(
                    activeIndex: _isVoiceMode ? 1 : 0,
                    onChanged: (i) => setState(() => _isVoiceMode = i == 1),
                    segments: [
                      CleverToggleSegment(
                        label: l10n.cleverToggleType,
                        icon: Icons.edit_outlined,
                      ),
                      CleverToggleSegment(
                        label: l10n.cleverToggleDictate,
                        icon: Icons.mic_none,
                      ),
                    ],
                  ),
                  const SizedBox(height: CleverSpacing.space24),
                  Text(
                    widget.existing == null
                        ? l10n.addExperience
                        : l10n.editExperienceTitle,
                    style: CleverTypography.h1.copyWith(
                      color: CleverColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: CleverSpacing.space24),
                  if (_isVoiceMode)
                    CleverDictatePanel(
                      entityType: 'experience',
                      onParsed: (data) {
                        setState(() {
                          void apply(
                            String? value,
                            TextEditingController controller,
                          ) {
                            if (value != null && value.isNotEmpty) {
                              controller.text = value;
                            }
                          }

                          apply(data['jobTitle']?.toString(), _titleCtrl);
                          apply(data['companyName']?.toString(), _companyCtrl);
                          apply(data['startDate']?.toString(), _startCtrl);
                          apply(data['endDate']?.toString(), _endCtrl);
                          apply(data['description']?.toString(), _descCtrl);
                        });
                      },
                      items: [
                        CleverDictateItem(
                          label: l10n.jobTitle,
                          captured: _titleCtrl.text.isNotEmpty,
                          onEdit: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _titleFocus.requestFocus();
                            });
                          },
                        ),
                        CleverDictateItem(
                          label: l10n.company,
                          captured: _companyCtrl.text.isNotEmpty,
                          onEdit: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _companyFocus.requestFocus();
                            });
                          },
                        ),
                        CleverDictateItem(
                          label: '${l10n.startDate} & ${l10n.endDate}',
                          captured: _startCtrl.text.isNotEmpty,
                          onEdit: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _pickDate(_startCtrl);
                            });
                          },
                        ),
                        CleverDictateItem(
                          label: l10n.shortDescription,
                          captured: _descCtrl.text.isNotEmpty,
                          onEdit: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _descFocus.requestFocus();
                            });
                          },
                        ),
                      ],
                    )
                  else ...[
                    CleverTextField(
                      controller: _titleCtrl,
                      focusNode: _titleFocus,
                      hintText: l10n.jobTitle,
                      surface: CleverFieldSurface.filled,
                      textInputAction: TextInputAction.next,
                      validator: (v) => v!.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: CleverSpacing.space16),
                    CleverTextField(
                      controller: _companyCtrl,
                      focusNode: _companyFocus,
                      hintText: l10n.company,
                      surface: CleverFieldSurface.filled,
                      textInputAction: TextInputAction.next,
                      validator: (v) => v!.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: CleverSpacing.space16),
                    Row(
                      children: [
                        Expanded(
                          child: _LegacyDateField(
                            controller: _startCtrl,
                            hint: l10n.selectDate,
                            icon: Icons.calendar_today,
                            onTap: () => _pickDate(_startCtrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LegacyDateField(
                            controller: _endCtrl,
                            hint: l10n.untilNow,
                            icon: Icons.event,
                            onTap: () => _pickDate(_endCtrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CleverSpacing.space16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.shortDescription,
                          style: CleverTypography.bodySm.copyWith(
                            color: CleverColors.textSecondary,
                          ),
                        ),
                        if (_isRewriting)
                          SizedBox(
                            height: 16,
                            width: 100,
                            child: SpinningTextLoader(
                              texts: [
                                l10n.improving,
                                l10n.rephrasing,
                                l10n.polishing,
                              ],
                              style: CleverTypography.bodySm.copyWith(
                                color: CleverColors.textPrimary,
                              ),
                              interval: const Duration(milliseconds: 800),
                            ),
                          )
                        else
                          InkWell(
                            onTap: _rewriteDescription,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 14,
                                  color: CleverColors.bgAction,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.rewriteAI,
                                  style: CleverTypography.bodySm.copyWith(
                                    color: CleverColors.bgAction,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: CleverSpacing.space8),
                    CleverTextField(
                      controller: _descCtrl,
                      focusNode: _descFocus,
                      hintText: l10n.descriptionHint,
                      surface: CleverFieldSurface.filled,
                      maxLines: 4,
                      validator: (v) => v!.isEmpty ? l10n.requiredField : null,
                    ),
                  ],
                  const SizedBox(height: CleverSpacing.space24),
                  CleverNavActionBar(
                    tone: CleverNavTone.orange,
                    onBack: _handlePop,
                    nextLabel: l10n.save,
                    onNext: _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Interim date field for the manual tab (restyled with the tab pass).
class _LegacyDateField extends StatelessWidget {
  const _LegacyDateField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.onTap,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CleverTextField(
      controller: controller,
      hintText: hint,
      surface: CleverFieldSurface.filled,
      prefixIcon: icon,
      readOnly: true,
      onTap: onTap,
    );
  }
}
