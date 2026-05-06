import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class PhotoToggleSettings extends ConsumerStatefulWidget {
  final String? photoUrl;
  final bool usePhoto;
  final Function(bool) onToggleChanged;
  final Function(bool) onUploadingChanged;

  const PhotoToggleSettings({
    super.key,
    required this.photoUrl,
    required this.usePhoto,
    required this.onToggleChanged,
    required this.onUploadingChanged,
  });

  @override
  ConsumerState<PhotoToggleSettings> createState() =>
      _PhotoToggleSettingsState();
}

class _PhotoToggleSettingsState extends ConsumerState<PhotoToggleSettings> {
  bool _isUploading = false;

  void _setUploading(bool val) {
    setState(() => _isUploading = val);
    widget.onUploadingChanged(val);
  }

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image == null) return;

    _setUploading(true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        if (mounted)
          throw Exception(AppLocalizations.of(context)!.userNotLoggedIn);
        return;
      }

      final storageService = StorageService();
      final downloadUrl = await storageService.uploadProfilePhoto(
        File(image.path),
        userId,
      );

      if (downloadUrl != null) {
        ref.read(profileControllerProvider.notifier).updatePhoto(downloadUrl);
        await ref.read(profileControllerProvider.notifier).saveProfile();

        widget.onToggleChanged(true);

        if (mounted) {
          CustomSnackBar.showSuccess(
            context,
            AppLocalizations.of(context)!.photoUpdateSuccess,
          );
        }
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
        _setUploading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasPhoto = widget.photoUrl != null && widget.photoUrl!.isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isUploading
          ? _buildUploadingState(l10n, colorScheme)
          : (!hasPhoto
                ? _buildEmptyState(l10n, colorScheme)
                : _buildFilledState(l10n, colorScheme)),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, ColorScheme colorScheme) {
    return InkWell(
      onTap: _pickAndUploadPhoto,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo_outlined,
                color: colorScheme.surface,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.includeProfilePhoto,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: -0.5,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.uploadInstruction,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadingState(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.uploadingPhoto,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledState(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: _pickAndUploadPhoto,
              child: Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.onSurface.withValues(alpha: 0.1),
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.photoUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.2,
                          ),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.includeProfilePhoto,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: -0.5,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.usingMasterPhoto,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: widget.usePhoto,
              onChanged: widget.onToggleChanged,
              activeTrackColor: colorScheme.onSurface,
              activeThumbColor: colorScheme.surface,
              inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.1),
              inactiveThumbColor: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
