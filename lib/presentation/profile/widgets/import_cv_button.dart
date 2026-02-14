import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/cv_import_provider.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../utils/cv_import_handler.dart';

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
      onPressed: () => CVImportHandler.showImportDialog(
        context: context,
        ref: ref,
        onImportSuccess: onImportSuccess,
      ),
      icon: const Icon(Icons.upload_file),
      label: const Text('Import dari CV yang udah ada'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }
}
