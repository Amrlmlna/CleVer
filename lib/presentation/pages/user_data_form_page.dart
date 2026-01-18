import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/cv_creation_provider.dart';

class UserDataFormPage extends ConsumerStatefulWidget {
  const UserDataFormPage({super.key});

  @override
  ConsumerState<UserDataFormPage> createState() => _UserDataFormPageState();
}

class _UserDataFormPageState extends ConsumerState<UserDataFormPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  
  // TODO: Add controllers for lists (Education, Experience) - simplified for MVP first pass

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
      setState(() {
        _currentStep += 1;
      });
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
        // TODO: Pass actual lists
        experience: const [],
        education: const [],
        skills: const ['Leadership', 'Communication'], // Mock skills for now
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
              content: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Experience & Education'),
              isActive: _currentStep >= 1,
              content: const Column(
                children: [
                  Text('Experience and Education forms will go here.'),
                  // Placeholder for list editors
                ],
              ),
            ),
            Step(
              title: const Text('Skills'),
              isActive: _currentStep >= 2,
              content: const Column(
                children: [
                   Text('Skills input will go here.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
