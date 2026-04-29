import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../data/datasources/ocr_datasource.dart';
import '../../../../domain/entities/subject.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../common/widgets/app_loading_screen.dart';
import '../../../cv/providers/cv_generation_provider.dart';

class StudyCardScanner extends ConsumerWidget {
  final Function({String? gpa, required List<Subject> subjects}) onResult;

  const StudyCardScanner({super.key, required this.onResult});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      onPressed: () => _showScanOptions(context, ref),
      icon: const Icon(Icons.document_scanner, size: 18),
      label: Text(AppLocalizations.of(context)!.scanKHS),
      style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
    );
  }

  void _showScanOptions(BuildContext context, WidgetRef ref) {
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
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
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
                      _processScan(context, ref, ImageSource.camera);
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildScanOption(
                    context: sheetContext,
                    icon: Icons.photo_library_outlined,
                    label: AppLocalizations.of(context)!.gallery,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _processScan(context, ref, ImageSource.gallery);
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildScanOption(
                    context: sheetContext,
                    icon: Icons.picture_as_pdf_outlined,
                    label: AppLocalizations.of(context)!.pdfFile,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _processScan(context, ref, null); // null means PDF
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
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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

  Future<void> _processScan(
    BuildContext context,
    WidgetRef ref,
    ImageSource? source,
  ) async {
    bool loadingShown = false;
    final localization = AppLocalizations.of(context)!;
    final ocrService = OCRDataSource();

    try {
      final String? text;

      void showLoading() {
        if (!loadingShown && context.mounted) {
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
        if (loadingShown && context.mounted) Navigator.pop(context);
        return;
      }

      final repository = ref.read(cvRepositoryProvider);
      final result = await repository.parseStudyCard(text);

      if (loadingShown && context.mounted) {
        Navigator.pop(context);
        loadingShown = false;
      }

      onResult(gpa: result.gpa, subjects: result.subjects);
    } catch (e) {
      if (loadingShown && context.mounted) {
        Navigator.pop(context);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${localization.unknownError}: $e')),
        );
      }
    }
  }
}
