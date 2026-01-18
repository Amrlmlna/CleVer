import 'package:flutter/material.dart';

class JobDetailsForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const JobDetailsForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'What job are you applying for?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'The AI will tailor your CV content specifically for this role.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 32),
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Job Title',
            hintText: 'e.g. Senior Product Manager',
            prefixIcon: Icon(Icons.work_outline),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a job title';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Job Description (Optional)',
            hintText: 'Paste key requirements or responsibilities here...',
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.description_outlined),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          maxLines: 5,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
