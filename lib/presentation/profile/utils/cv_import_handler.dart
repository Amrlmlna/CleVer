import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/cv_import_provider.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../../../core/utils/custom_snackbar.dart';

class CVImportHandler {
  static void showImportDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Function(UserProfile) onImportSuccess,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Import CV'),
        content: const Text('Pilih cara import CV kamu:'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _importFromImage(context, ref, ImageSource.camera, onImportSuccess);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Kamera'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _importFromImage(context, ref, ImageSource.gallery, onImportSuccess);
            },
            icon: const Icon(Icons.photo_library),
            label: const Text('Galeri'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _importFromPDF(context, ref, onImportSuccess);
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('File PDF'),
          ),
        ],
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
              pageBuilder: (ctx, _, __) => const AppLoadingScreen(
                badge: "IMPORTING CV",
                messages: [
                  "Membaca CV...",
                  "Mengekstrak data...",
                  "Menyusun profil...",
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
              pageBuilder: (ctx, _, __) => const AppLoadingScreen(
                badge: "IMPORTING CV",
                messages: [
                  "Membaca PDF...",
                  "Mengekstrak data...",
                  "Menyusun profil...",
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
        CustomSnackBar.showWarning(context, 'Tidak ada teks yang ditemukan di CV');
        break;
      case CVImportStatus.error:
        CustomSnackBar.showError(context, 'Gagal mengimport CV. Coba lagi ya!');
        break;
      default:
        break;
    }
  }
}
