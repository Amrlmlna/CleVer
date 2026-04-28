import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/cv_import_provider.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../widgets/import_success_bottom_sheet.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class CVImportHandler {
  static void showImportDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Function(UserProfile) onImportSuccess,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 12, 32, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppLocalizations.of(context)!.importCVTitle.toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.importCVMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              _buildOption(
                context: sheetContext,
                icon: Icons.camera_alt_rounded,
                label: AppLocalizations.of(context)!.camera,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _importFromImage(
                    context,
                    ref,
                    ImageSource.camera,
                    onImportSuccess,
                  );
                },
              ),
              _buildOption(
                context: sheetContext,
                icon: Icons.photo_library_rounded,
                label: AppLocalizations.of(context)!.gallery,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _importFromImage(
                    context,
                    ref,
                    ImageSource.gallery,
                    onImportSuccess,
                  );
                },
              ),
              _buildOption(
                context: sheetContext,
                icon: Icons.picture_as_pdf_rounded,
                label: AppLocalizations.of(context)!.pdfFile,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _importFromPDF(context, ref, onImportSuccess);
                },
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.colorScheme.onSurface, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                size: 16,
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

    final result = await ref
        .read(cvImportProvider.notifier)
        .importFromImage(
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

    final result = await ref
        .read(cvImportProvider.notifier)
        .importFromPDF(
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
          ImportSuccessBottomSheet.show(
            context: context,
            extractedProfile: result.extractedProfile!,
            onContinue: () => onImportSuccess(result.extractedProfile!),
          );
        }
        break;
      case CVImportStatus.cancelled:
        break;
      case CVImportStatus.noText:
        CustomSnackBar.showWarning(
          context,
          AppLocalizations.of(context)!.noTextFoundInCV,
        );
        break;
      case CVImportStatus.error:
        CustomSnackBar.showError(
          context,
          AppLocalizations.of(context)!.importFailedMessage,
        );
        break;
      default:
        break;
    }
  }
}
