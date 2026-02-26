import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/location_picker.dart';
import '../providers/profile_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class PersonalInfoForm extends ConsumerStatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;
  final bool showPhotoField;

  const PersonalInfoForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
    required this.birthDateController,
    required this.genderController,
    this.showPhotoField = true,
  });

  @override
  ConsumerState<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends ConsumerState<PersonalInfoForm> {
  final _picker = ImagePicker();
  final _storageService = StorageService();
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image == null) return;

      setState(() => _isUploading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          CustomSnackBar.showError(
            context,
            AppLocalizations.of(context)!.userNotLoggedIn,
          );
        }
        return;
      }

      final downloadUrl = await _storageService.uploadProfilePhoto(
        File(image.path),
        user.uid,
      );

      if (downloadUrl != null && mounted) {
        ref.read(profileControllerProvider.notifier).updatePhoto(downloadUrl);
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = ref
        .watch(profileControllerProvider)
        .currentProfile
        .photoUrl;

    return Column(
      children: [
        if (widget.showPhotoField) ...[
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[850],
                    backgroundImage: photoUrl != null
                        ? NetworkImage(photoUrl)
                        : null,
                    child: photoUrl == null && !_isUploading
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                if (_isUploading)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
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
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.1),
                          width: 1.0,
                        ),
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
          const SizedBox(height: 24),
        ],
        CustomTextFormField(
          controller: widget.nameController,
          labelText: AppLocalizations.of(context)!.fullName,
          prefixIcon: Icons.person_outline,
          validator: (v) =>
              v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
          textInputAction: TextInputAction.next,
          isDark: true,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: widget.emailController,
          labelText: AppLocalizations.of(context)!.email,
          prefixIcon: Icons.email_outlined,
          validator: (v) =>
              v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          isDark: true,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: widget.phoneController,
          labelText: AppLocalizations.of(context)!.phoneNumber,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          isDark: true,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final now = DateTime.now();
                  final date = await showDatePicker(
                    context: context,
                    initialDate: now.subtract(const Duration(days: 365 * 20)),
                    firstDate: DateTime(1900),
                    lastDate: now,
                  );
                  if (date != null) {
                    widget.birthDateController.text =
                        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    controller: widget.birthDateController,
                    labelText: AppLocalizations.of(context)!.birthDate,
                    prefixIcon: Icons.cake_outlined,
                    isDark: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: widget.genderController.text.isEmpty
                    ? null
                    : widget.genderController.text,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.gender,
                  prefixIcon: const Icon(Icons.person_search_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
                dropdownColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white,
                items: [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text(AppLocalizations.of(context)!.male),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text(AppLocalizations.of(context)!.female),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    widget.genderController.text = val;
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LocationPicker(controller: widget.locationController, isDark: true),
      ],
    );
  }
}
