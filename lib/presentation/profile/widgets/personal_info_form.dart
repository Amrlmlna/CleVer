import 'package:flutter/material.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/location_picker.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'profile_photo_uploader.dart';

class PersonalInfoForm extends StatefulWidget {
  final TextEditingController? nameController;
  final TextEditingController? emailController;
  final TextEditingController? phoneController;
  final TextEditingController? locationController;
  final TextEditingController? birthDateController;
  final TextEditingController? genderController;
  final String? photoUrl;
  final ValueChanged<String>? onPhotoChanged;
  final bool showPhotoField;

  const PersonalInfoForm({
    super.key,
    this.nameController,
    this.emailController,
    this.phoneController,
    this.locationController,
    this.birthDateController,
    this.genderController,
    this.photoUrl,
    this.onPhotoChanged,
    this.showPhotoField = true,
  });

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();

    _nameController = widget.nameController ?? TextEditingController();
    _emailController = widget.emailController ?? TextEditingController();
    _phoneController = widget.phoneController ?? TextEditingController();
    _locationController = widget.locationController ?? TextEditingController();
    _birthDateController =
        widget.birthDateController ?? TextEditingController();
    _genderController = widget.genderController ?? TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showPhotoField) ...[
          ProfilePhotoUploader(
            photoUrl: widget.photoUrl,
            onPhotoChanged: widget.onPhotoChanged,
          ),
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
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _buildGenderToggle(
                  context,
                  'Male',
                  Icons.male_rounded,
                  AppLocalizations.of(context)!.male,
                ),
                const SizedBox(width: 4),
                _buildGenderToggle(
                  context,
                  'Female',
                  Icons.female_rounded,
                  AppLocalizations.of(context)!.female,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderToggle(
    BuildContext context,
    String value,
    IconData icon,
    String label,
  ) {
    final isSelected = _getNormalizedGender(_genderController.text) == value;
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _genderController.text = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _getNormalizedGender(String text) {
    final lower = text.trim().toLowerCase();
    if (lower == 'male' || lower == 'pria' || lower == 'laki-laki') return 'Male';
    if (lower == 'female' || lower == 'wanita' || lower == 'perempuan') return 'Female';
    return null;
  }
}
