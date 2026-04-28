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
                AppLocalizations.of(context)!.importCVTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context)!.importCVMessage,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
                      _importFromImage(
                        context,
                        ref,
                        ImageSource.camera,
                        onImportSuccess,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildOption(
                    context: sheetContext,
                    icon: Icons.photo_library_outlined,
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
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.04),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurface,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
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
