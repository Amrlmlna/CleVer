import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/cv_import_provider.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class CVImportHandler {
  static void showImportDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Function(UserProfile) onImportSuccess,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.importCVTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context)!.importCVMessage,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildOption(
                    context: sheetContext,
                    icon: Icons.camera_alt_outlined,
                    label: AppLocalizations.of(context)!.camera,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _importFromImage(context, ref, ImageSource.camera, onImportSuccess);
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildOption(
                    context: sheetContext,
                    icon: Icons.photo_library_outlined,
                    label: AppLocalizations.of(context)!.gallery,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _importFromImage(context, ref, ImageSource.gallery, onImportSuccess);
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildOption(
                    context: sheetContext,
                    icon: Icons.picture_as_pdf_outlined,
                    label: AppLocalizations.of(context)!.pdfFile,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _importFromPDF(context, ref, onImportSuccess);
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

  static Widget _buildOption({
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
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withValues(alpha: 0.04),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white70, size: 28),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _importFromImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
    Function(UserProfile) onImportSuccess,
  ) async {
    bool loadingShown = false;

    final result = await ref.read(cvImportProvider.notifier).importFromImage(
      source,
      onProcessingStart: () {
        if (!loadingShown) {
          loadingShown = true;
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: false,
              pageBuilder: (ctx, _, __) => AppLoadingScreen(
                badge: AppLocalizations.of(context)!.importingCVBadge,
                messages: [
                  AppLocalizations.of(context)!.readingCV,
                  AppLocalizations.of(context)!.extractingData,
                  AppLocalizations.of(context)!.compilingProfile,
                ],
              ),
            ),
          );
        }
      },
    );

    if (loadingShown && context.mounted) {
      Navigator.pop(context);
    }

    _handleResult(context, ref, result, onImportSuccess);
  }

  static Future<void> _importFromPDF(
    BuildContext context,
    WidgetRef ref,
    Function(UserProfile) onImportSuccess,
  ) async {
    bool loadingShown = false;

    final result = await ref.read(cvImportProvider.notifier).importFromPDF(
      onProcessingStart: () {
        if (!loadingShown) {
          loadingShown = true;
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: false,
              pageBuilder: (ctx, _, __) => AppLoadingScreen(
                badge: AppLocalizations.of(context)!.importingCVBadge,
                messages: [
                  AppLocalizations.of(context)!.readingPDF,
                  AppLocalizations.of(context)!.extractingData,
                  AppLocalizations.of(context)!.compilingProfile,
                ],
              ),
            ),
          );
        }
      },
    );

    if (loadingShown && context.mounted) {
      Navigator.pop(context);
    }

    _handleResult(context, ref, result, onImportSuccess);
  }

  static void _handleResult(
    BuildContext context,
    WidgetRef ref,
    CVImportState result,
    Function(UserProfile) onImportSuccess,
  ) {
    if (!context.mounted) return;

    switch (result.status) {
      case CVImportStatus.success:
        if (result.extractedProfile != null) {
          onImportSuccess(result.extractedProfile!);
        }
        break;
      case CVImportStatus.cancelled:
        // User cancelled, do nothing
        break;
      case CVImportStatus.noText:
        CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.noTextFoundInCV);
        break;
      case CVImportStatus.error:
        CustomSnackBar.showError(context, AppLocalizations.of(context)!.importFailedMessage);
        break;
      default:
        break;
    }
  }
}
