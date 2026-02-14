import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/cv_import_provider.dart';
import '../../common/widgets/app_loading_screen.dart';

/// Reusable CV Import Button
/// Shows dialog with Camera/Gallery/PDF options and handles import flow
class ImportCVButton extends ConsumerWidget {
  final Function(UserProfile) onImportSuccess;

  const ImportCVButton({
    super.key,
    required this.onImportSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => _showImportDialog(context, ref),
      icon: const Icon(Icons.upload_file),
      label: const Text('Import dari CV yang udah ada'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Import CV'),
        content: const Text('Pilih cara import CV kamu:'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _importFromImage(context, ref, ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Kamera'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _importFromImage(context, ref, ImageSource.gallery);
            },
            icon: const Icon(Icons.photo_library),
            label: const Text('Galeri'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _importFromPDF(context, ref);
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('File PDF'),
          ),
        ],
      ),
    );
  }

  Future<void> _importFromImage(BuildContext context, WidgetRef ref, ImageSource source) async {
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

    _handleResult(context, ref, result);
  }

  Future<void> _importFromPDF(BuildContext context, WidgetRef ref) async {
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

    _handleResult(context, ref, result);
  }

  void _handleResult(BuildContext context, WidgetRef ref, CVImportState result) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Tidak ada teks yang ditemukan di CV'),
            backgroundColor: Colors.orange,
          ),
        );
        break;
      case CVImportStatus.error:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Gagal mengimport CV. Coba lagi ya!'),
            backgroundColor: Colors.red,
          ),
        );
        break;
      default:
        break;
    }
  }
}
