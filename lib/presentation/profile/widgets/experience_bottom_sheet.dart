import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../common/widgets/spinning_text_loader.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/unsaved_changes_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../common/widgets/sheet/sheet_header.dart';
import '../../common/widgets/sheet/sheet_action_buttons.dart';
import '../../common/widgets/voice_dictation_panel.dart';

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
          child: ExperienceBottomSheet(existing: existing),
        ),
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

    Experience? savedExp;
    final result = await UnsavedChangesDialog.show(
      context,
      onSave: () async {
        if (_formKey.currentState!.validate()) {
          savedExp = Experience(
            id:
                widget.existing?.id ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            jobTitle: _titleCtrl.text,
            companyName: _companyCtrl.text,
            startDate: _startCtrl.text,
            endDate: _endCtrl.text.isEmpty ? null : _endCtrl.text,
            description: _descCtrl.text,
          );
        }
      },
      onDiscard: () async {
        // Just return true to the dialog
      },
    );

    if (result == true && mounted) {
      setState(() => _canPopNow = true);
      Navigator.pop(context, savedExp);
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
                        ? localization.addExperience
                        : localization.editExperienceTitle,
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
                      entityType: 'experience',
                      instruction: localization.voiceExplainExperience,
                      checklistItems: [
                        VoiceChecklistItem(
                          label: localization.jobTitle,
                          isFilled: _titleCtrl.text.isNotEmpty,
                          onTap: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _titleFocus.requestFocus();
                            });
                          },
                        ),
                        VoiceChecklistItem(
                          label: localization.company,
                          isFilled: _companyCtrl.text.isNotEmpty,
                          onTap: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _companyFocus.requestFocus();
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
                          label: localization.shortDescription,
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
                          if (data['jobTitle'] != null &&
                              data['jobTitle'].toString().isNotEmpty) {
                            _titleCtrl.text = data['jobTitle'];
                          }
                          if (data['companyName'] != null &&
                              data['companyName'].toString().isNotEmpty) {
                            _companyCtrl.text = data['companyName'];
                          }
                          if (data['startDate'] != null &&
                              data['startDate'].toString().isNotEmpty) {
                            _startCtrl.text = data['startDate'];
                          }
                          if (data['endDate'] != null &&
                              data['endDate'].toString().isNotEmpty) {
                            _endCtrl.text = data['endDate'];
                          }
                          if (data['description'] != null &&
                              data['description'].toString().isNotEmpty) {
                            _descCtrl.text = data['description'];
                          }
                        });
                      },
                    )
                  else ...[
                    CustomTextFormField(
                      controller: _titleCtrl,
                      focusNode: _titleFocus,
                      labelText: localization.jobTitle,
                      hintText: localization.jobTitleHint,
                      validator: (v) =>
                          v!.isEmpty ? localization.requiredField : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _companyCtrl,
                      focusNode: _companyFocus,
                      labelText: localization.company,
                      hintText: localization.companyPlaceholder,
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
                            hintText: localization.selectDate,
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
                            hintText: localization.untilNow,
                            readOnly: true,
                            prefixIcon: Icons.event,
                            onTap: () => _pickDate(_endCtrl),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localization.shortDescription,
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
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _descCtrl,
                      focusNode: _descFocus,
                      labelText: '',
                      hintText: localization.descriptionHint,
                      maxLines: 4,
                      validator: (v) =>
                          v!.isEmpty ? localization.requiredField : null,
                    ),
                  ],
                  const SizedBox(height: 32),
                  SheetActionButtons(
                    onSave: _save,
                    onCancel: _handlePop,
                    voiceEntityType: _isVoiceMode ? null : 'experience',
                    onVoiceParsed: _isVoiceMode
                        ? null
                        : (data) {
                            setState(() {
                              if (data['jobTitle'] != null &&
                                  data['jobTitle'].toString().isNotEmpty) {
                                _titleCtrl.text = data['jobTitle'];
                              }
                              if (data['companyName'] != null &&
                                  data['companyName'].toString().isNotEmpty) {
                                _companyCtrl.text = data['companyName'];
                              }
                              if (data['startDate'] != null &&
                                  data['startDate'].toString().isNotEmpty) {
                                _startCtrl.text = data['startDate'];
                              }
                              if (data['endDate'] != null &&
                                  data['endDate'].toString().isNotEmpty) {
                                _endCtrl.text = data['endDate'];
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
