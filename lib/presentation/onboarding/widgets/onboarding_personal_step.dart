import 'package:flutter/material.dart';
import '../../profile/widgets/personal_info_form.dart';

class OnboardingPersonalStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;

  const OnboardingPersonalStep({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
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
          ),
        ],
      ),
    );
  }
}
