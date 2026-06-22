import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/subject.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/university_picker.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/unsaved_changes_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../common/widgets/sheet/sheet_header.dart';
import '../../common/widgets/sheet/sheet_action_buttons.dart';
import '../../common/widgets/voice_dictation_panel.dart';

import './education/subject_list_section.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../common/widgets/spinning_text_loader.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../../../core/providers/locale_provider.dart';

class EducationBottomSheet extends ConsumerStatefulWidget {
  final Education? existing;

  const EducationBottomSheet({super.key, this.existing});

  static Future<Education?> show(BuildContext context, {Education? existing}) {
    return showModalBottomSheet<Education>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.sheetSurface,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Theme(
        data: AppTheme.sheetTheme,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EducationBottomSheet(existing: existing),
        ),
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
  late TextEditingController _descCtrl;
  late TextEditingController _gpaCtrl;
  late List<Subject> _subjects;
  bool _canPopNow = false;
  bool _isRewriting = false;
  bool _isVoiceMode = true;

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
    _descCtrl = TextEditingController(text: widget.existing?.description);
    _gpaCtrl = TextEditingController(text: widget.existing?.gpa);
    _subjects = List.from(widget.existing?.subjects ?? []);
    if (widget.existing != null) {
      _isVoiceMode = false; // default to manual form when editing
    }
  }

  @override
  void dispose() {
    _schoolCtrl.dispose();
    _degreeCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _descCtrl.dispose();
    _gpaCtrl.dispose();
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

    Education? savedEdu;
    final result = await UnsavedChangesDialog.show(
      context,
      onSave: () async {
        if (_formKey.currentState!.validate()) {
          savedEdu = Education(
            id:
                widget.existing?.id ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            schoolName: _schoolCtrl.text,
            degree: _degreeCtrl.text,
            startDate: _startCtrl.text,
            endDate: _endCtrl.text.isEmpty ? null : _endCtrl.text,
            description: _descCtrl.text,
            gpa: _gpaCtrl.text,
            subjects: _subjects,
          );
        }
      },
      onDiscard: () async {},
    );

    if (result == true && mounted) {
      setState(() => _canPopNow = true);
      Navigator.pop(context, savedEdu);
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

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: _canPopNow,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handlePop();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SheetHeader(
                    title: widget.existing == null
                        ? localization.addEducation
                        : localization.editEducation,
                    onClosing: _handlePop,
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _isVoiceMode = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _isVoiceMode
                                    ? colorScheme.onSurface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                localization.voiceMode,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _isVoiceMode
                                      ? colorScheme.surface
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _isVoiceMode = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: !_isVoiceMode
                                    ? colorScheme.onSurface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                localization.voiceForm,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: !_isVoiceMode
                                      ? colorScheme.surface
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (_isVoiceMode)
                    VoiceDictationPanel(
                      entityType: 'education',
                      instruction: localization.voiceExplainEducation,
                      checklistItems: [
                        VoiceChecklistItem(
                          label: localization.schoolLabel,
                          isFilled: _schoolCtrl.text.isNotEmpty,
                          onTap: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _schoolFocus.requestFocus();
                            });
                          },
                        ),
                        VoiceChecklistItem(
                          label: localization.degree,
                          isFilled: _degreeCtrl.text.isNotEmpty,
                          onTap: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _degreeFocus.requestFocus();
                            });
                          },
                        ),
                        VoiceChecklistItem(
                          label:
                              '${localization.startDate} & ${localization.endDate}',
                          isFilled: _startCtrl.text.isNotEmpty,
                          onTap: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _pickDate(_startCtrl);
                            });
                          },
                        ),
                        VoiceChecklistItem(
                          label: localization.educationDescriptionLabel,
                          isFilled: _descCtrl.text.isNotEmpty,
                          onTap: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _descFocus.requestFocus();
                            });
                          },
                        ),
                      ],
                      onParsed: (data) {
                        setState(() {
                          if (data['schoolName'] != null &&
                              data['schoolName'].toString().isNotEmpty) {
                            _schoolCtrl.text = data['schoolName'];
                          }
                          if (data['degree'] != null &&
                              data['degree'].toString().isNotEmpty) {
                            _degreeCtrl.text = data['degree'];
                          }
                          if (data['startDate'] != null &&
                              data['startDate'].toString().isNotEmpty) {
                            _startCtrl.text = data['startDate'];
                          }
                          if (data['endDate'] != null &&
                              data['endDate'].toString().isNotEmpty) {
                            _endCtrl.text = data['endDate'];
                          }
                          if (data['gpa'] != null &&
                              data['gpa'].toString().isNotEmpty) {
                            _gpaCtrl.text = data['gpa'];
                          }
                          if (data['description'] != null &&
                              data['description'].toString().isNotEmpty) {
                            _descCtrl.text = data['description'];
                          }
                        });
                      },
                    )
                  else ...[
                    UniversityPicker(
                      controller: _schoolCtrl,
                      focusNode: _schoolFocus,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _degreeCtrl,
                      focusNode: _degreeFocus,
                      labelText: localization.degree,
                      hintText: localization.degreeHint,
                      validator: (v) =>
                          v!.isEmpty ? localization.requiredField : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            controller: _startCtrl,
                            labelText: localization.startDate,
                            hintText: localization.year,
                            readOnly: true,
                            prefixIcon: Icons.calendar_today,
                            onTap: () => _pickDate(_startCtrl),
                            validator: (v) =>
                                v!.isEmpty ? localization.requiredField : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextFormField(
                            controller: _endCtrl,
                            labelText: localization.endDate,
                            hintText: localization.year,
                            readOnly: true,
                            prefixIcon: Icons.event,
                            onTap: () => _pickDate(_endCtrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomTextFormField(
                            controller: _gpaCtrl,
                            focusNode: _gpaFocus,
                            labelText: localization.gpaLabel,
                            hintText: localization.gpaHint,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            prefixIcon: Icons.star_outline,
                          ),
                        ),
                        const Expanded(flex: 3, child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localization.educationDescriptionLabel,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        _isRewriting
                            ? SizedBox(
                                height: 16,
                                width: 100,
                                child: SpinningTextLoader(
                                  texts: [
                                    localization.improving,
                                    localization.rephrasing,
                                    localization.polishing,
                                  ],
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  interval: const Duration(milliseconds: 800),
                                ),
                              )
                            : TextButton.icon(
                                onPressed: _rewriteDescription,
                                icon: Icon(
                                  Icons.auto_awesome,
                                  size: 14,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                label: Text(
                                  localization.rewriteAI,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                      ],
                    ),
                    CustomTextFormField(
                      controller: _descCtrl,
                      focusNode: _descFocus,
                      labelText: '', // Label is now in the Row above
                      hintText: localization.educationDescriptionHint,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
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
                  const SizedBox(height: 32),
                  SheetActionButtons(
                    onSave: _save,
                    onCancel: _handlePop,
                    voiceEntityType: _isVoiceMode ? null : 'education',
                    onVoiceParsed: _isVoiceMode
                        ? null
                        : (data) {
                            setState(() {
                              if (data['schoolName'] != null &&
                                  data['schoolName'].toString().isNotEmpty) {
                                _schoolCtrl.text = data['schoolName'];
                              }
                              if (data['degree'] != null &&
                                  data['degree'].toString().isNotEmpty) {
                                _degreeCtrl.text = data['degree'];
                              }
                              if (data['startDate'] != null &&
                                  data['startDate'].toString().isNotEmpty) {
                                _startCtrl.text = data['startDate'];
                              }
                              if (data['endDate'] != null &&
                                  data['endDate'].toString().isNotEmpty) {
                                _endCtrl.text = data['endDate'];
                              }
                              if (data['gpa'] != null &&
                                  data['gpa'].toString().isNotEmpty) {
                                _gpaCtrl.text = data['gpa'];
                              }
                              if (data['description'] != null &&
                                  data['description'].toString().isNotEmpty) {
                                _descCtrl.text = data['description'];
                              }
                            });
                          },
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
