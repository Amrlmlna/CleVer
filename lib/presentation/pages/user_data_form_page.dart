import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/cv_creation_provider.dart';
import '../widgets/form/education_list_form.dart';
import '../widgets/form/experience_list_form.dart';
import '../widgets/form/skills_input_form.dart';
import '../widgets/form/personal_info_form.dart';

class UserDataFormPage extends ConsumerStatefulWidget {
  const UserDataFormPage({super.key});

  @override
  ConsumerState<UserDataFormPage> createState() => _UserDataFormPageState();
}

class _UserDataFormPageState extends ConsumerState<UserDataFormPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Personal Info Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  
  // Lists
  List<Experience> _experience = [];
  List<Education> _education = [];
  List<String> _skills = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    if (_currentStep < 2) {
      if (_currentStep == 0) {
        // Validate personal info specifically before moving
        if (_formKey.currentState!.validate()) {
          setState(() {
            _currentStep += 1;
          });
        }
      } else {
         setState(() {
            _currentStep += 1;
          });
      }
    } else {
      _submit();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        fullName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        location: _locationController.text,
        experience: _experience,
        education: _education,
        skills: _skills.isNotEmpty ? _skills : ['Leadership', 'Communication'], // Fallback if empty, or just empty
      );

      ref.read(cvCreationProvider.notifier).setUserProfile(profile);
      context.push('/create/style-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Details'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 2 ? 'Finish' : 'Next'),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Personal Info'),
              isActive: _currentStep >= 0,
              content: PersonalInfoForm(
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                locationController: _locationController,
              ),
            ),
            Step(
              title: const Text('Experience & Education'),
              isActive: _currentStep >= 1,
              content: Column(
                children: [
                  ExperienceListForm(
                    experiences: _experience,
                    onChanged: (val) => setState(() => _experience = val),
                  ),
                  const Divider(height: 32),
                  EducationListForm(
                    education: _education,
                    onChanged: (val) => setState(() => _education = val),
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Skills'),
              isActive: _currentStep >= 2,
              content: SkillsInputForm(
                skills: _skills,
                onChanged: (val) => setState(() => _skills = val),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
