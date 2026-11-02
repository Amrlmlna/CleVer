import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../data/datasources/ocr_datasource.dart';
import '../../../../domain/entities/subject.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common/widgets/clever/clever_button.dart';
import '../../../common/widgets/clever/clever_text_field.dart';
import '../../../common/widgets/app_loading_screen.dart';
import '../../../cv/providers/cv_generation_provider.dart';

/// "mata kuliah / pelajaran" section per staging: header + small orange
/// add button, and the total-count row. Tapping either opens the add /
/// manage sheet. KHS scan (camera/gallery/PDF → OCR → parse-study-card)
/// preserved from the legacy StudyCardScanner.
class CleverSubjectsSection extends StatelessWidget {
  const CleverSubjectsSection({
    super.key,
    required this.subjects,
    required this.onChanged,
    required this.onScanResult,
  });

  final List<Subject> subjects;
  final ValueChanged<List<Subject>> onChanged;
  final void Function({String? gpa, required List<Subject> subjects})
  onScanResult;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.academicSubjects,
                style: CleverTypography.bodyStrong.copyWith(
                  color: CleverColors.textPrimary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _showSheet(context),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: CleverColors.bgAction,
                  borderRadius: BorderRadius.circular(CleverRadius.field),
                ),
                child: const Icon(
                  Icons.add,
                  size: 20,
                  color: CleverColors.textOnDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: CleverSpacing.space12),
        InkWell(
          onTap: () => _showSheet(context),
          borderRadius: BorderRadius.circular(CleverRadius.button),
          child: Container(
            height: 51,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: CleverColors.surfaceField,
              borderRadius: BorderRadius.circular(CleverRadius.button),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.archive_outlined,
                  size: 16,
                  color: CleverColors.bgAction,
                ),
                const SizedBox(width: CleverSpacing.space12),
                Text(
                  l10n.total,
                  style: CleverTypography.body.copyWith(
                    color: CleverColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
                const Spacer(),
                Text(
                  '${subjects.length}',
                  style: CleverTypography.bodyStrong.copyWith(
                    color: CleverColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
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
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: CleverSubjectsSheet(
          subjects: subjects,
          onChanged: onChanged,
          onScanResult: onScanResult,
        ),
      ),
    );
  }
}

/// Add/manage sheet: existing subjects (removable), the add form, and the
/// KHS scan entry point.
class CleverSubjectsSheet extends ConsumerStatefulWidget {
  const CleverSubjectsSheet({
    super.key,
    required this.subjects,
    required this.onChanged,
    required this.onScanResult,
  });

  final List<Subject> subjects;
  final ValueChanged<List<Subject>> onChanged;
  final void Function({String? gpa, required List<Subject> subjects})
  onScanResult;

  @override
  ConsumerState<CleverSubjectsSheet> createState() =>
      _CleverSubjectsSheetState();
}

class _CleverSubjectsSheetState extends ConsumerState<CleverSubjectsSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _gradeCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _gradeCtrl.dispose();
    super.dispose();
  }

  void _addSubject() {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      CustomSnackBar.showWarning(context, l10n.requiredField);
      return;
    }

    final isDuplicate = widget.subjects.any(
      (s) => s.name.toLowerCase() == name.toLowerCase(),
    );
    if (isDuplicate) {
      CustomSnackBar.showWarning(context, l10n.cvDataExists);
      return;
    }

    widget.onChanged([
      ...widget.subjects,
      Subject(
        name: name,
        grade: _gradeCtrl.text.isEmpty ? null : _gradeCtrl.text,
        description: _descCtrl.text.isEmpty ? null : _descCtrl.text,
      ),
    ]);

    _nameCtrl.clear();
    _descCtrl.clear();
    _gradeCtrl.clear();
    if (mounted) setState(() {});
  }

  void _removeSubject(int index) {
    final updated = [...widget.subjects]..removeAt(index);
    widget.onChanged(updated);
  }

  /// KHS scan — same OCR → parse-study-card flow as the legacy scanner.
  Future<void> _scanKHS(ImageSource? source) async {
    final l10n = AppLocalizations.of(context)!;
    final ocrService = OCRDataSource();
    var loadingShown = false;

    try {
      void showLoading() {
        if (!loadingShown) {
          loadingShown = true;
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: false,
              pageBuilder: (ctx, _, __) => AppLoadingScreen(
                badge: l10n.scanningKHSBadge,
                messages: [
                  l10n.readingKHS,
                  l10n.extractingGPA,
                  l10n.compilingProfile,
                ],
              ),
            ),
          );
        }
      }

      showLoading();

      final String? text;
      if (source != null) {
        text = await ocrService.extractTextFromImage(source);
      } else {
        text = await ocrService.extractTextFromPDF();
      }

      if (!mounted) return;
      final navigator = Navigator.of(context);

      if (text == null || text.isEmpty) {
        if (loadingShown && navigator.canPop()) {
          navigator.pop();
        }
        return;
      }

      final repository = ref.read(cvRepositoryProvider);
      final result = await repository.parseStudyCard(text);

      if (!mounted) return;
      if (loadingShown && navigator.canPop()) {
        navigator.pop();
        loadingShown = false;
      }

      widget.onScanResult(gpa: result.gpa, subjects: result.subjects);
    } catch (e) {
      if (loadingShown && mounted && Navigator.of(context).canPop()) {
        Navigator.pop(context);
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.unknownError}: $e')));
      }
    } finally {
      ocrService.dispose();
    }
  }

  void _showScanOptions(BuildContext sheetContext) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: sheetContext,
      backgroundColor: CleverColors.bgCanvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      builder: (scanContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 23, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ScanOptionRow(
                icon: Icons.photo_camera_outlined,
                label: l10n.camera,
                onTap: () {
                  Navigator.pop(scanContext);
                  _scanKHS(ImageSource.camera);
                },
              ),
              const SizedBox(height: CleverSpacing.space12),
              _ScanOptionRow(
                icon: Icons.photo_library_outlined,
                label: l10n.gallery,
                onTap: () {
                  Navigator.pop(scanContext);
                  _scanKHS(ImageSource.gallery);
                },
              ),
              const SizedBox(height: CleverSpacing.space12),
              _ScanOptionRow(
                icon: Icons.picture_as_pdf_outlined,
                label: l10n.pdfFile,
                onTap: () {
                  Navigator.pop(scanContext);
                  _scanKHS(null);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(31, 16, 33, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 47,
                height: 4,
                decoration: BoxDecoration(
                  color: CleverColors.surfaceInverse.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: CleverSpacing.space16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.addSubject,
                    style: CleverTypography.h3.copyWith(
                      color: CleverColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showScanOptions(context),
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.document_scanner_outlined,
                      size: 24,
                      color: CleverColors.bgAction,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: CleverSpacing.space16),
            if (widget.subjects.isNotEmpty) ...[
              for (var i = 0; i < widget.subjects.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: CleverSpacing.space8),
                  child: _SubjectRow(
                    subject: widget.subjects[i],
                    onDelete: () => _removeSubject(i),
                  ),
                ),
              const SizedBox(height: CleverSpacing.space8),
            ],
            CleverTextField(
              controller: _nameCtrl,
              hintText: l10n.subjectName,
              surface: CleverFieldSurface.filled,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: CleverSpacing.space12),
            CleverTextField(
              controller: _descCtrl,
              hintText: l10n.whatDidYouLearn,
              surface: CleverFieldSurface.filled,
              maxLines: 2,
            ),
            const SizedBox(height: CleverSpacing.space12),
            CleverTextField(
              controller: _gradeCtrl,
              hintText: l10n.gradeOptional,
              surface: CleverFieldSurface.filled,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: CleverSpacing.space16),
            CleverButton(label: l10n.add, onTap: _addSubject),
          ],
        ),
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.subject, required this.onDelete});

  final Subject subject;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: CleverColors.surfaceSelected,
        borderRadius: BorderRadius.circular(CleverRadius.button),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              subject.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CleverTypography.bodyStrong.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
          ),
          if (subject.grade != null) ...[
            const SizedBox(width: CleverSpacing.space8),
            Text(
              subject.grade!,
              style: CleverTypography.micro.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
          ],
          const SizedBox(width: CleverSpacing.space8),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.cancel,
              size: 16,
              color: CleverColors.bgAction,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanOptionRow extends StatelessWidget {
  const _ScanOptionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(CleverRadius.card),
        child: Container(
          padding: const EdgeInsets.all(CleverSpacing.space16),
          decoration: BoxDecoration(
            color: CleverColors.surfaceSelected,
            borderRadius: BorderRadius.circular(CleverRadius.card),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: CleverColors.surfaceInverse),
              const SizedBox(width: CleverSpacing.space16),
              Expanded(
                child: Text(
                  label,
                  style: CleverTypography.bodyStrong.copyWith(
                    color: CleverColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                size: 18,
                color: CleverColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
