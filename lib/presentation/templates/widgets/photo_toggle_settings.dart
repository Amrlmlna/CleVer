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
  ConsumerState<PhotoToggleSettings> createState() => _PhotoToggleSettingsState();
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
        if (mounted) throw Exception(AppLocalizations.of(context)!.userNotLoggedIn);
        return;
      }

      final storageService = StorageService();
      final downloadUrl = await storageService.uploadProfilePhoto(File(image.path), userId);

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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isUploading 
          ? _buildUploadingState(l10n)
          : (!hasPhoto ? _buildEmptyState(l10n) : _buildFilledState(l10n)),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    final primaryColor = Theme.of(context).primaryColor;
    return InkWell(
      onTap: _pickAndUploadPhoto,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_a_photo_outlined, color: primaryColor, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.includeProfilePhoto,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.uploadInstruction,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadingState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          ),
          const SizedBox(height: 16),
          Text(l10n.uploadingPhoto, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildFilledState(AppLocalizations l10n) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _pickAndUploadPhoto,
                  child: Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 2),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.photoUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt, 
                            size: 12, 
                            color: Theme.of(context).colorScheme.onPrimary,
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
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        l10n.usingMasterPhoto,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: widget.usePhoto,
                  onChanged: widget.onToggleChanged,
                  activeColor: primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
