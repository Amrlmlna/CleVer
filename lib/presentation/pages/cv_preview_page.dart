import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/pdf_generator.dart';
import '../providers/cv_generation_provider.dart';

class CVPreviewPage extends ConsumerWidget {
  const CVPreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cvAsyncValue = ref.watch(generatedCVProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your CV Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
               final currentData = ref.read(generatedCVProvider).asData?.value;
               if (currentData != null) {
                 PDFGenerator.generateAndPrint(currentData);
               }
            },
          ),
        ],
      ),
      body: cvAsyncValue.when(
        data: (cvData) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Name & Contact)
              Center(
                child: Column(
                  children: [
                    Text(
                      cvData.userProfile.fullName.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${cvData.userProfile.email} | ${cvData.userProfile.phoneNumber ?? ""} | ${cvData.userProfile.location ?? ""}',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Divider(height: 32, thickness: 1.5),

              // Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionHeader(title: 'PROFESSIONAL SUMMARY'),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: () {
                      _showEditDialog(
                        context, 
                        'Edit Summary', 
                        cvData.generatedSummary, 
                        (val) => ref.read(generatedCVProvider.notifier).updateSummary(val),
                      );
                    },
                  ),
                ],
              ),
              Text(
                cvData.generatedSummary,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),

              // Skills
              _SectionHeader(title: 'SKILLS'),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: cvData.tailoredSkills.map((skill) => Chip(
                  label: Text(skill),
                  backgroundColor: Colors.grey[200],
                )).toList(),
              ),
              const SizedBox(height: 24),

              // Experience 
              _SectionHeader(title: 'EXPERIENCE'),
              if (cvData.userProfile.experience.isEmpty)
                 const Text('No experience listed.'),
              // TODO: Render experience list
              
              const SizedBox(height: 24),

              // Education
              _SectionHeader(title: 'EDUCATION'),
               if (cvData.userProfile.education.isEmpty)
                 const Text('No education listed.'),
               // TODO: Render education list

            ],
          ),
        ),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('AI is tailoring your CV...'),
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

void _showEditDialog(BuildContext context, String title, String initialValue, Function(String) onSave) {
  final controller = TextEditingController(text: initialValue);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        maxLines: 5,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onSave(controller.text);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
