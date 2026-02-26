import 'package:flutter/material.dart';
import '../../profile/widgets/personal_info_form.dart';

class OnboardingPersonalStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;

  const OnboardingPersonalStep({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
    required this.birthDateController,
    required this.genderController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PersonalInfoForm(
            nameController: nameController,
            emailController: emailController,
            phoneController: phoneController,
            locationController: locationController,
            birthDateController: birthDateController,
            genderController: genderController,
            showPhotoField: false,
          ),
        ],
      ),
    );
  }
}
