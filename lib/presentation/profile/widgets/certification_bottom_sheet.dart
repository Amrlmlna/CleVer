import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/certification.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/clever/clever_confirm_sheet.dart';
import '../../common/widgets/clever/clever_dictate_panel.dart';
import '../../common/widgets/clever/clever_form_toggle.dart';
import '../../common/widgets/clever/clever_nav_action_bar.dart';
import '../../common/widgets/clever/clever_text_field.dart';
import '../../common/widgets/spinning_text_loader.dart';
import '../../cv/providers/cv_generation_provider.dart';

/// Add/edit certification form — Clever cream sheet with ketik/dikte.
class CertificationBottomSheet extends ConsumerStatefulWidget {
  final Certification? existing;

  const CertificationBottomSheet({super.key, this.existing});

  static Future<Certification?> show(
    BuildContext context, {
    Certification? existing,
  }) {
    return showModalBottomSheet<Certification>(
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
        child: CertificationBottomSheet(existing: existing),
      ),
    );
  }

  @override
  ConsumerState<CertificationBottomSheet> createState() =>
      _CertificationBottomSheetState();
}

class _CertificationBottomSheetState
    extends ConsumerState<CertificationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _issuerController;
  late TextEditingController _descController;
  late DateTime _selectedDate;
  late DateTime _originalDate;
  bool _isRewriting = false;
  bool _canPopNow = false;
  bool _isVoiceMode = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _issuerFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name);
    _issuerController = TextEditingController(text: widget.existing?.issuer);
    _descController = TextEditingController(text: widget.existing?.description);
    _selectedDate = widget.existing?.date ?? DateTime.now();
    _originalDate = _selectedDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    _descController.dispose();
    _nameFocus.dispose();
    _issuerFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  bool get _isDirty {
    return _nameController.text != (widget.existing?.name ?? '') ||
        _issuerController.text != (widget.existing?.issuer ?? '') ||
        _descController.text != (widget.existing?.description ?? '') ||
        _selectedDate != _originalDate;
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
      final cert = Certification(
        id:
            widget.existing?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        issuer: _issuerController.text,
        description: _descController.text,
        date: _selectedDate,
      );
      setState(() => _canPopNow = true);
      Navigator.pop(context, cert);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _rewriteDescription() async {
    if (_descController.text.isEmpty) {
      CustomSnackBarHelper.showWarning(
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
      if (_nameController.text.isNotEmpty ||
          _issuerController.text.isNotEmpty) {
        instruction =
            "Rewrite this certification description to be professional for the ${_nameController.text} certificate${_issuerController.text.isNotEmpty ? " issued by ${_issuerController.text}" : ""}. Focus on the skills validated and the professional significance of this certification.";
      }

      final newText = await repository.rewriteContent(
        _descController.text,
        locale: locale.languageCode,
        instruction: instruction,
      );

      if (mounted) {
        setState(() {
          _descController.text = newText;
          _isRewriting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRewriting = false);
        CustomSnackBarHelper.showError(
          context,
          AppLocalizations.of(context)!.rewriteFailed('$e'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateLabel =
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';

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
                    l10n.addCertification,
                    style: CleverTypography.h1.copyWith(
                      color: CleverColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: CleverSpacing.space24),
                  if (_isVoiceMode)
                    CleverDictatePanel(
                      entityType: 'certification',
                      onParsed: (data) {
                        setState(() {
                          if (data['name'] != null &&
                              data['name'].toString().isNotEmpty) {
                            _nameController.text = data['name'];
                          }
                          if (data['issuer'] != null &&
                              data['issuer'].toString().isNotEmpty) {
                            _issuerController.text = data['issuer'];
                          }
                          if (data['date'] != null &&
                              data['date'].toString().isNotEmpty) {
                            _selectedDate = _parseCertDate(
                              data['date'].toString(),
                            );
                          }
                          if (data['description'] != null &&
                              data['description'].toString().isNotEmpty) {
                            _descController.text = data['description'];
                          }
                        });
                      },
                      items: [
                        CleverDictateItem(
                          label: l10n.certificationName,
                          captured: _nameController.text.isNotEmpty,
                          onEdit: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _nameFocus.requestFocus();
                            });
                          },
                        ),
                        CleverDictateItem(
                          label: l10n.issuer,
                          captured: _issuerController.text.isNotEmpty,
                          onEdit: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _issuerFocus.requestFocus();
                            });
                          },
                        ),
                        CleverDictateItem(
                          label: l10n.dateLabel,
                          captured: true,
                          onEdit: () {
                            setState(() => _isVoiceMode = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _selectDate(context);
                            });
                          },
                        ),
                        CleverDictateItem(
                          label: l10n.shortDescription,
                          captured: _descController.text.isNotEmpty,
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
                      controller: _nameController,
                      focusNode: _nameFocus,
                      hintText: l10n.certificationName,
                      surface: CleverFieldSurface.filled,
                      textInputAction: TextInputAction.next,
                      validator: (v) => v!.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: CleverSpacing.space16),
                    CleverTextField(
                      controller: _issuerController,
                      focusNode: _issuerFocus,
                      hintText: l10n.issuer,
                      surface: CleverFieldSurface.filled,
                      textInputAction: TextInputAction.next,
                      validator: (v) => v!.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: CleverSpacing.space16),
                    // Single date row per staging ("dd/mm/yy").
                    InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(CleverRadius.button),
                      child: Container(
                        height: CleverSizes.field,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: CleverColors.surfaceField,
                          borderRadius: BorderRadius.circular(
                            CleverRadius.button,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 19,
                              color: CleverColors.textPrimary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              dateLabel,
                              style: CleverTypography.bodyStrong.copyWith(
                                color: CleverColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      controller: _descController,
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

DateTime _parseCertDate(String raw) {
  final dateStr = raw.trim();
  if (RegExp(r'^\d{4}-\d{2}$').hasMatch(dateStr)) {
    final parsed = DateTime.tryParse('$dateStr-01');
    if (parsed != null) return parsed;
  }
  return DateTime.tryParse(dateStr) ?? DateTime.now();
}

/// Legacy-parity snackbar shim (the certification form has no rewrite
/// backend call yet — kept for copy parity with the other sheets).
class CustomSnackBarHelper {
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: CleverTypography.body.copyWith(color: CleverColors.textOnDark),
        ),
        backgroundColor: CleverColors.bgDanger,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: CleverTypography.body.copyWith(color: CleverColors.textOnDark),
        ),
        backgroundColor: CleverColors.bgDanger,
      ),
    );
  }
}
