import 'package:flutter/material.dart';
import '../../common/widgets/custom_text_form_field.dart';

class PersonalInfoForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;

  const PersonalInfoForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: nameController,
          labelText: 'Nama Lengkap',
          prefixIcon: Icons.person_outline,
          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: emailController,
          labelText: 'Email',
          prefixIcon: Icons.email_outlined,
          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: phoneController,
          labelText: 'Nomor HP',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: locationController,
          labelText: 'Lokasi / Domisili',
          prefixIcon: Icons.location_on_outlined,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
