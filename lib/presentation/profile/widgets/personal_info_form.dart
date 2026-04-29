import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/location_picker.dart';
import '../providers/profile_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../domain/entities/user_profile.dart';
import 'profile_photo_uploader.dart';

class PersonalInfoForm extends ConsumerStatefulWidget {
  final TextEditingController? nameController;
  final TextEditingController? emailController;
  final TextEditingController? phoneController;
  final TextEditingController? locationController;
  final TextEditingController? birthDateController;
  final TextEditingController? genderController;
  final bool showPhotoField;

  const PersonalInfoForm({
    super.key,
    this.nameController,
    this.emailController,
    this.phoneController,
    this.locationController,
    this.birthDateController,
    this.genderController,
    this.showPhotoField = true,
  });

  @override
  ConsumerState<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends ConsumerState<PersonalInfoForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    final initialProfile = ref.read(profileControllerProvider).currentProfile;

    _nameController =
        widget.nameController ??
        TextEditingController(text: initialProfile.fullName);
    _emailController =
        widget.emailController ??
        TextEditingController(text: initialProfile.email);
    _phoneController =
        widget.phoneController ??
        TextEditingController(text: initialProfile.phoneNumber ?? '');
    _locationController =
        widget.locationController ??
        TextEditingController(text: initialProfile.location ?? '');
    _birthDateController =
        widget.birthDateController ??
        TextEditingController(text: initialProfile.birthDate ?? '');
    _genderController =
        widget.genderController ??
        TextEditingController(text: initialProfile.gender ?? '');

    _nameController.addListener(_onNameChanged);
    _emailController.addListener(_onEmailChanged);
    _phoneController.addListener(_onPhoneChanged);
    _locationController.addListener(_onLocationChanged);
    _birthDateController.addListener(_onBirthDateChanged);
    _genderController.addListener(_onGenderChanged);
  }

  void _onNameChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updateName(_nameController.text);
  }

  void _onEmailChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updateEmail(_emailController.text);
  }

  void _onPhoneChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updatePhone(_phoneController.text);
  }

  void _onLocationChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updateLocation(_locationController.text);
  }

  void _onBirthDateChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updateBirthDate(_birthDateController.text);
  }

  void _onGenderChanged() {
    ref
        .read(profileControllerProvider.notifier)
        .updateGender(_genderController.text);
  }

  @override
  void dispose() {
    // Only dispose if we created them locally
    if (widget.nameController == null) _nameController.dispose();
    if (widget.emailController == null) _emailController.dispose();
    if (widget.phoneController == null) _phoneController.dispose();
    if (widget.locationController == null) _locationController.dispose();
    if (widget.birthDateController == null) _birthDateController.dispose();
    if (widget.genderController == null) _genderController.dispose();
    super.dispose();
  }

  void _syncControllers(UserProfile profile) {
    if (_nameController.text != profile.fullName) {
      _nameController.text = profile.fullName;
    }
    if (_emailController.text != profile.email) {
      _emailController.text = profile.email;
    }
    if (_phoneController.text != (profile.phoneNumber ?? '')) {
      _phoneController.text = profile.phoneNumber ?? '';
    }
    if (_locationController.text != (profile.location ?? '')) {
      _locationController.text = profile.location ?? '';
    }
    if (_birthDateController.text != (profile.birthDate ?? '')) {
      _birthDateController.text = profile.birthDate ?? '';
    }
    if (_genderController.text != (profile.gender ?? '')) {
      _genderController.text = profile.gender ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(profileControllerProvider, (previous, next) {
      if (previous?.currentProfile != next.currentProfile) {
        _syncControllers(next.currentProfile);
      }
    });

    return Column(
      children: [
        if (widget.showPhotoField) ...[
          const ProfilePhotoUploader(),
          const SizedBox(height: 24),
        ],
        CustomTextFormField(
          controller: _nameController,
          labelText: AppLocalizations.of(context)!.fullName,
          prefixIcon: Icons.person_outline,
          validator: (v) =>
              v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _emailController,
          labelText: AppLocalizations.of(context)!.email,
          prefixIcon: Icons.email_outlined,
          validator: (v) =>
              v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _phoneController,
          labelText: AppLocalizations.of(context)!.phoneNumber,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        _buildBirthDateAndGender(context),
        const SizedBox(height: 16),
        LocationPicker(controller: _locationController),
      ],
    );
  }

  Widget _buildBirthDateAndGender(BuildContext context) {
    return Row(
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
                _birthDateController.text =
                    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
              }
            },
            child: AbsorbPointer(
              child: CustomTextFormField(
                controller: _birthDateController,
                labelText: AppLocalizations.of(context)!.birthDate,
                prefixIcon: Icons.cake_outlined,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _genderController.text.isEmpty
                ? null
                : _genderController.text,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.gender,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.person_search_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            dropdownColor: Theme.of(context).cardTheme.color,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            iconEnabledColor: Theme.of(context).colorScheme.onSurfaceVariant,
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
                _genderController.text = val;
              }
            },
          ),
        ),
      ],
    );
  }
}
