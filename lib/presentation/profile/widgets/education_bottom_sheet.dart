import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/education.dart';
import '../../../domain/entities/subject.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_dimensions.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../common/widgets/clever/clever_confirm_sheet.dart';
import '../../common/widgets/clever/clever_dictate_panel.dart';
import '../../common/widgets/clever/clever_form_toggle.dart';
import '../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../common/widgets/clever/clever_text_field.dart';
import '../../common/widgets/spinning_text_loader.dart';
import '../../cv/providers/cv_generation_provider.dart';
import 'education/subject_list_section.dart';
import '../../common/widgets/university_picker.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

/// Add/edit education form — Clever cream sheet with ketik/dikte toggle.
/// Courses (subjects) and KHS scan reuse the legacy SubjectListSection.
class EducationBottomSheet extends ConsumerStatefulWidget {
  final Education? existing;

  const EducationBottomSheet({super.key, this.existing});

  static Future<Education?> show(BuildContext context, {Education? existing}) {
    return showModalBottomSheet<Education>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: CleverColors.bgCanvas,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EducationBottomSheet(existing: existing),
      ),
    );
  }

  @override
  ConsumerState<EducationBottomSheet> createState() =>
      _EducationBottomSheetState();
}

class _EducationBottomSheetState extends ConsumerState<EducationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schoolCtrl;
  late TextEditingController _degreeCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;
  late TextEditingController _gpaCtrl;
  late TextEditingController _descCtrl;
  late List<Subject> _subjects;

  bool _isRewriting = false;
  bool _canPopNow = false;
  bool _isVoiceMode = false;

  final FocusNode _schoolFocus = FocusNode();
  final FocusNode _degreeFocus = FocusNode();
  final FocusNode _gpaFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _schoolCtrl = TextEditingController(text: widget.existing?.schoolName);
    _degreeCtrl = TextEditingController(text: widget.existing?.degree);
    _startCtrl = TextEditingController(text: widget.existing?.startDate);
    _endCtrl = TextEditingController(text: widget.existing?.endDate);
    _gpaCtrl = TextEditingController(text: widget.existing?.gpa);
    _descCtrl = TextEditingController(text: widget.existing?.description);
    _subjects = List.from(widget.existing?.subjects ?? []);
  }

  @override
  void dispose() {
    _schoolCtrl.dispose();
    _degreeCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _gpaCtrl.dispose();
    _descCtrl.dispose();
    _schoolFocus.dispose();
    _degreeFocus.dispose();
    _gpaFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  bool get _isDirty {
    return _schoolCtrl.text != (widget.existing?.schoolName ?? '') ||
        _degreeCtrl.text != (widget.existing?.degree ?? '') ||
        _startCtrl.text != (widget.existing?.startDate ?? '') ||
        _endCtrl.text != (widget.existing?.endDate ?? '') ||
        _descCtrl.text != (widget.existing?.description ?? '') ||
        _gpaCtrl.text != (widget.existing?.gpa ?? '') ||
        _subjects.length != (widget.existing?.subjects.length ?? 0);
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
      final edu = Education(
        id:
            widget.existing?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        schoolName: _schoolCtrl.text,
        degree: _degreeCtrl.text,
        startDate: _startCtrl.text,
        endDate: _endCtrl.text.isEmpty ? null : _endCtrl.text,
        description: _descCtrl.text,
        gpa: _gpaCtrl.text.isEmpty ? null : _gpaCtrl.text,
        subjects: _subjects,
      );
      setState(() => _canPopNow = true);
      Navigator.pop(context, edu);
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
      if (_schoolCtrl.text.isNotEmpty || _degreeCtrl.text.isNotEmpty) {
        instruction =
            "Rewrite this education description to be professional for a ${_degreeCtrl.text} degree${_schoolCtrl.text.isNotEmpty ? " from ${_schoolCtrl.text}" : ""}. Focus on relevant coursework, academic achievements, and skills acquired.";
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
                        icon: Icons.graphic_eq,
                      ),
                    ],
                  ),
                  const SizedBox(height: CleverSpacing.space24),
                  Text(
                    l10n.addEducation,
                    style: CleverTypography.h1.copyWith(
                      color: CleverColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: CleverSpacing.space24),
                  if (_isVoiceMode)
                    CleverDictatePanel(
                      entityType: 'education',
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

                          apply(data['schoolName']?.toString(), _schoolCtrl);
                          apply(data['degree']?.toString(), _degreeCtrl);
                          apply(data['startDate']?.toString(), _startCtrl);
                          apply(data['endDate']?.toString(), _endCtrl);
                          apply(data['gpa']?.toString(), _gpaCtrl);
                          apply(data['description']?.toString(), _descCtrl);
                        });
                      },
                      items: [
                        CleverDictateItem(
                          label: l10n.schoolLabel,
                          captured: _schoolCtrl.text.isNotEmpty,
                          onEdit: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _schoolFocus.requestFocus();
                            });
                          },
                        ),
                        CleverDictateItem(
                          label: l10n.degree,
                          captured: _degreeCtrl.text.isNotEmpty,
                          onEdit: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _degreeFocus.requestFocus();
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
                          label: l10n.educationDescriptionLabel,
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
                    UniversityPicker(
                      controller: _schoolCtrl,
                      focusNode: _schoolFocus,
                    ),
                    const SizedBox(height: CleverSpacing.space16),
                    CleverTextField(
                      controller: _degreeCtrl,
                      focusNode: _degreeFocus,
                      hintText: l10n.degree,
                      surface: CleverFieldSurface.filled,
                      textInputAction: TextInputAction.next,
                      validator: (v) => v!.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: CleverSpacing.space16),
                    Row(
                      children: [
                        Expanded(
                          child: CleverTextField(
                            controller: _startCtrl,
                            hintText: l10n.year,
                            surface: CleverFieldSurface.filled,
                            prefixIcon: Icons.calendar_today,
                            readOnly: true,
                            onTap: () => _pickDate(_startCtrl),
                            validator: (v) =>
                                v!.isEmpty ? l10n.requiredField : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CleverTextField(
                            controller: _endCtrl,
                            hintText: l10n.year,
                            surface: CleverFieldSurface.filled,
                            prefixIcon: Icons.event,
                            readOnly: true,
                            onTap: () => _pickDate(_endCtrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CleverSpacing.space16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CleverTextField(
                            controller: _gpaCtrl,
                            focusNode: _gpaFocus,
                            hintText: l10n.gpaLabel,
                            surface: CleverFieldSurface.filled,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const Expanded(flex: 3, child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: CleverSpacing.space16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.educationDescriptionLabel,
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
                      hintText: l10n.educationDescriptionHint,
                      surface: CleverFieldSurface.filled,
                      maxLines: 3,
                    ),
                    const SizedBox(height: CleverSpacing.space24),
                    // Courses + KHS scan — legacy section, full logic.
                    SubjectListSection(
                      subjects: _subjects,
                      onChanged: (newList) =>
                          setState(() => _subjects = newList),
                      onScanResult: ({gpa, required subjects}) {
                        setState(() {
                          if (_gpaCtrl.text.isEmpty && gpa != null) {
                            _gpaCtrl.text = gpa;
                          }
                          for (final newSub in subjects) {
                            if (!_subjects.any(
                              (s) =>
                                  s.name.toLowerCase() ==
                                  newSub.name.toLowerCase(),
                            )) {
                              _subjects.add(newSub);
                            }
                          }
                        });
                      },
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
