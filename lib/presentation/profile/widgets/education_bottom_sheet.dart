import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../domain/entities/subject.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../../../data/datasources/ocr_datasource.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/university_picker.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/unsaved_changes_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../common/widgets/app_loading_screen.dart';
import 'package:intl/intl.dart';

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
  ConsumerState<EducationBottomSheet> createState() => _EducationBottomSheetState();
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
  }

  @override
  void dispose() {
    _schoolCtrl.dispose();
    _degreeCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _descCtrl.dispose();
    _gpaCtrl.dispose();
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
    if (!_isDirty) {
      Navigator.pop(context);
      return;
    }

    UnsavedChangesDialog.show(
      context,
      onSave: _save,
      onDiscard: () => Navigator.pop(context),
    );
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
      Navigator.pop(context, edu);
    }
  }

  Future<void> _scanKHS() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.scanKHSTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context)!.scanKHSMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.sheetOnSurfaceVar,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildScanOption(
                    context: sheetContext,
                    icon: Icons.camera_alt_outlined,
                    label: AppLocalizations.of(context)!.camera,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _processScan(ImageSource.camera);
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildScanOption(
                    context: sheetContext,
                    icon: Icons.photo_library_outlined,
                    label: AppLocalizations.of(context)!.gallery,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _processScan(ImageSource.gallery);
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildScanOption(
                    context: sheetContext,
                    icon: Icons.picture_as_pdf_outlined,
                    label: AppLocalizations.of(context)!.pdfFile,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _processScan(null); // null means PDF
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(14),
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 28,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processScan(ImageSource? source) async {
    bool loadingShown = false;
    final localization = AppLocalizations.of(context)!;
    final ocrService = OCRDataSource();

    try {
      final String? text;
      
      void showLoading() {
        if (!loadingShown && mounted) {
          loadingShown = true;
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: false,
              pageBuilder: (ctx, _, __) => AppLoadingScreen(
                badge: localization.scanningKHSBadge,
                messages: [
                  localization.readingKHS,
                  localization.extractingGPA,
                  localization.compilingProfile,
                ],
              ),
            ),
          );
        }
      }

      if (source != null) {
        final XFile? file = await ImagePicker().pickImage(source: source);
        if (file == null) return;
        showLoading();
        text = await ocrService.extractTextFromFilePath(file.path);
      } else {
        final file = await ocrService.pickPDFFile();
        if (file == null) return;
        showLoading();
        text = await ocrService.extractTextFromPDFFile(file);
      }

      if (text == null || text.isEmpty) {
        if (loadingShown && mounted) Navigator.pop(context);
        return;
      }

      final repository = ref.read(cvRepositoryProvider);
      final result = await repository.parseStudyCard(text);

      if (loadingShown && mounted) {
        Navigator.pop(context);
        loadingShown = false;
      }

      if (mounted) {
        setState(() {
          if (_gpaCtrl.text.isEmpty && result.gpa != null) {
            _gpaCtrl.text = result.gpa!;
          }

          for (final newSub in result.subjects) {
            if (!_subjects.any((s) => s.name.toLowerCase() == newSub.name.toLowerCase())) {
              _subjects.add(newSub);
            }
          }
        });
      }
    } catch (e) {
      if (loadingShown && mounted) {
        Navigator.pop(context);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${localization.unknownError}: $e')),
        );
      }
    }
  }

  void _addSubject() {
    final nameCtrl = TextEditingController();
    final gradeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localization.addSubject),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: localization.subjectName),
              autofocus: true,
            ),
            TextField(
              controller: gradeCtrl,
              decoration: InputDecoration(labelText: localization.gradeOptional),
            ),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(labelText: localization.whatDidYouLearn),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localization.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _subjects.add(Subject(
                    name: nameCtrl.text,
                    grade: gradeCtrl.text.isEmpty ? null : gradeCtrl.text,
                    description: descCtrl.text.isEmpty ? null : descCtrl.text,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: Text(localization.add),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );
    if (picked != null) {
      controller.text = DateFormat('MMM yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
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
                  Center(
                    child: GestureDetector(
                      onTap: _handlePop,
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.sheetHandle,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.existing == null
                        ? localization.addEducation
                        : localization.editEducation,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  UniversityPicker(controller: _schoolCtrl),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _degreeCtrl,
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
                            labelText: localization.gpaLabel,
                            hintText: localization.gpaHint,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            prefixIcon: Icons.star_outline,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(flex: 3, child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _descCtrl,
                      labelText: localization.educationDescriptionLabel,
                      hintText: localization.educationDescriptionHint,
                      maxLines: 3,
                    ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localization.academicSubjects,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _scanKHS,
                        icon: const Icon(Icons.document_scanner, size: 18),
                        label: Text(AppLocalizations.of(context)!.scanKHS),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_subjects.isEmpty)
                    Center(
                      child: Text(
                        localization.noSubjectsAdded,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.sheetOnSurfaceVar,
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _subjects.map((subject) {
                        return GestureDetector(
                          onTap: () {
                            final nameCtrl = TextEditingController(text: subject.name);
                            final gradeCtrl = TextEditingController(text: subject.grade);
                            final descCtrl = TextEditingController(text: subject.description);

                            final localization = AppLocalizations.of(context)!;
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(localization.editSubject),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameCtrl,
                                      decoration: InputDecoration(labelText: localization.subjectName),
                                      autofocus: true,
                                    ),
                                    TextField(
                                      controller: gradeCtrl,
                                      decoration: InputDecoration(labelText: localization.gradeOptional),
                                    ),
                                    TextField(
                                      controller: descCtrl,
                                      decoration: InputDecoration(labelText: localization.whatDidYouLearn),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(localization.cancel),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (nameCtrl.text.isNotEmpty) {
                                        setState(() {
                                          final index = _subjects.indexOf(subject);
                                          _subjects[index] = Subject(
                                            name: nameCtrl.text,
                                            grade: gradeCtrl.text.isEmpty ? null : gradeCtrl.text,
                                            description: descCtrl.text.isEmpty ? null : descCtrl.text,
                                          );
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(localization.update),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Chip(
                            label: Text(
                              '${subject.name}${subject.grade != null ? " (${subject.grade})" : ""}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 14),
                            onDeleted: () {
                              setState(() {
                                _subjects.remove(subject);
                              });
                            },
                            backgroundColor: AppColors.sheetInputFill,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _addSubject,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(localization.addSubjectManually),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        localization.saveAllCaps,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _handlePop,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        localization.cancel.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
