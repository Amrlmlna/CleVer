import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/certification.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/unsaved_changes_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../common/widgets/sheet/sheet_header.dart';
import '../../common/widgets/sheet/sheet_action_buttons.dart';
import '../../common/widgets/voice_input_pill.dart';

import '../../../../core/utils/custom_snackbar.dart';
import '../../common/widgets/spinning_text_loader.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../../../core/providers/locale_provider.dart';

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
          child: CertificationBottomSheet(existing: existing),
        ),
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
  bool _isRewriting = false;
  bool _canPopNow = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _issuerController = TextEditingController(
      text: widget.existing?.issuer ?? '',
    );
    _descController = TextEditingController(
      text: widget.existing?.description ?? '',
    );
    _selectedDate = widget.existing?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    return _nameController.text != (widget.existing?.name ?? '') ||
        _issuerController.text != (widget.existing?.issuer ?? '') ||
        _descController.text != (widget.existing?.description ?? '') ||
        _selectedDate != (widget.existing?.date ?? _selectedDate);
  }

  void _handlePop() async {
    if (_canPopNow) return;

    if (!_isDirty) {
      setState(() => _canPopNow = true);
      Navigator.pop(context);
      return;
    }

    Certification? savedCert;
    final result = await UnsavedChangesDialog.show(
      context,
      onSave: () async {
        if (_formKey.currentState!.validate()) {
          savedCert = Certification(
            id:
                widget.existing?.id ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            name: _nameController.text,
            issuer: _issuerController.text,
            description: _descController.text,
            date: _selectedDate,
          );
        }
      },
      onDiscard: () async {},
    );

    if (result == true && mounted) {
      setState(() => _canPopNow = true);
      Navigator.pop(context, savedCert);
    }
  }

  Future<void> _rewriteDescription() async {
    if (_descController.text.isEmpty) {
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
        CustomSnackBar.showError(context, 'Gagal rewrite: $e');
      }
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
        date: _selectedDate,
      );
      setState(() => _canPopNow = true);
      Navigator.of(context).pop(cert);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

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
                        ? localization.addCertification
                        : localization.editCertification,
                    onClosing: _handlePop,
                  ),

                  const SizedBox(height: 24),
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: localization.certificationName,
                    hintText: 'AWS Certified Cloud Practitioner',
                    validator: (v) =>
                        v!.isEmpty ? localization.requiredField : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _issuerController,
                    labelText: localization.issuer,
                    hintText: 'Amazon Web Services',
                    validator: (v) =>
                        v!.isEmpty ? localization.requiredField : null,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.dateLabel,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localization.shortDescription,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                                color: Theme.of(context).colorScheme.onSurface,
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
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                    ],
                  ),
                  CustomTextFormField(
                    controller: _descController,
                    labelText: '',
                    hintText: localization.descriptionHint,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  SheetActionButtons(
                    onSave: _save,
                    onCancel: _handlePop,
                    voiceEntityType: 'certification',
                    onVoiceParsed: (data) {
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
                          try {
                            _selectedDate = DateTime.parse(data['date']);
                          } catch (_) {}
                        }
                        if (data['description'] != null &&
                            data['description'].toString().isNotEmpty) {
                          _descController.text = data['description'];
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
