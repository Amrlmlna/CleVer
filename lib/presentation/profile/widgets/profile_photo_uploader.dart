import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../auth/providers/auth_state_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class ProfilePhotoUploader extends ConsumerStatefulWidget {
  final String? photoUrl;
  final ValueChanged<String>? onPhotoChanged;

  const ProfilePhotoUploader({super.key, this.photoUrl, this.onPhotoChanged});

  @override
  ConsumerState<ProfilePhotoUploader> createState() =>
      _ProfilePhotoUploaderState();
}

class _ProfilePhotoUploaderState extends ConsumerState<ProfilePhotoUploader> {
  final _picker = ImagePicker();
  final _storageService = StorageService();
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    try {
      final authState = ref.read(authStateProvider);
      final userId = authState.value?.uid;

      if (userId == null) {
        if (mounted) {
          CustomSnackBar.showError(
            context,
            AppLocalizations.of(context)!.userNotLoggedIn,
          );
        }
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image == null) return;

      setState(() => _isUploading = true);

      final file = File(image.path);
      final downloadUrl = await _storageService.uploadProfilePhoto(
        file,
        userId,
      );

      if (downloadUrl != null && mounted) {
        widget.onPhotoChanged?.call(downloadUrl);
        CustomSnackBar.showSuccess(
          context,
          AppLocalizations.of(context)!.photoUpdateSuccess,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(
          context,
          AppLocalizations.of(context)!.photoUpdateError(e.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = widget.photoUrl;

    return Center(
      child: Tooltip(
        message: AppLocalizations.of(context)!.profilePhotoExportTooltip,
        triggerMode: TooltipTriggerMode.tap,
        child: Stack(
          children: [
            GestureDetector(
              onTap: _pickAndUploadImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                backgroundImage: photoUrl != null
                    ? NetworkImage(photoUrl)
                    : null,
                onBackgroundImageError: photoUrl != null
                    ? (exception, stackTrace) {}
                    : null,
                child: photoUrl == null && !_isUploading
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )
                    : null,
              ),
            ),
            if (_isUploading)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickAndUploadImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
