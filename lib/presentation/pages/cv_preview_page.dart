import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/pdf_generator.dart';
import '../providers/cv_generation_provider.dart';
import '../providers/draft_provider.dart';
import '../widgets/common/ai_editable_text.dart';

class CVPreviewPage extends ConsumerWidget {
  const CVPreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cvAsyncValue = ref.watch(generatedCVProvider);
    final hasUnsavedChanges = ref.watch(unsavedChangesProvider);

    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text('You have unsaved changes. Do you want to save them before leaving?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Discard
                  ref.read(unsavedChangesProvider.notifier).state = false;
                  Navigator.of(context).pop(true);
                },
                child: const Text('Discard', style: TextStyle(color: Colors.red)),
              ),
              FilledButton(
                onPressed: () async {
                  final currentData = ref.read(generatedCVProvider).asData?.value;
                  if (currentData != null) {
                    await ref.read(draftsProvider.notifier).saveDraft(currentData);
                    ref.read(unsavedChangesProvider.notifier).state = false;
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Draft Saved')),
                      );
                      Navigator.of(context).pop(true);
                    }
                  }
                },
                child: const Text('Save & Exit'),
              ),
            ],
          ),
        );

        if (shouldPop == true && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
               if (hasUnsavedChanges) {
                  // Trigger PopScope manually
                  Navigator.of(context).maybePop();
               } else {
                  context.pop();
               }
            },
          ),
          actions: [
            TextButton(
               onPressed: () async {
                 final currentData = ref.read(generatedCVProvider).asData?.value;
                 if (currentData != null) {
                   await ref.read(draftsProvider.notifier).saveDraft(currentData);
                   ref.read(unsavedChangesProvider.notifier).state = false; // Reset dirty state
                   if (context.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Draft Saved')),
                     );
                   }
                 }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                 final currentData = ref.read(generatedCVProvider).asData?.value;
                 if (currentData != null) {
                   PDFGenerator.generateAndPrint(currentData);
                 }
              },
              child: const Text('Export PDF'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: cvAsyncValue.when(
        data: (cvData) {
          final notifier = ref.read(generatedCVProvider.notifier);
          final repo = ref.read(cvRepositoryProvider);

          return SingleChildScrollView(
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
                const _SectionHeader(title: 'PROFESSIONAL SUMMARY'),
                AIEditableText(
                  initialText: cvData.generatedSummary,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onSave: (val) => notifier.updateSummary(val),
                  onRewrite: (val) => repo.rewriteContent(val),
                ),
                const SizedBox(height: 24),

                // Skills
                const _SectionHeader(title: 'SKILLS'),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    ...cvData.tailoredSkills.map((skill) => Chip(
                      label: Text(skill),
                      backgroundColor: Colors.grey[200],
                    )),
                    ActionChip(
                       label: const Icon(Icons.add, size: 16),
                       padding: EdgeInsets.zero,
                       backgroundColor: Colors.white,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20),
                         side: BorderSide(color: Colors.grey.shade400, style: BorderStyle.solid), // Per user request "empty rectangle"ish but rounded
                       ),
                       onPressed: () async {
                         final newSkill = await showDialog<String>(
                           context: context,
                           builder: (context) {
                             String skill = '';
                             return AlertDialog(
                               title: const Text('Add Skill'),
                               content: TextField(
                                 autofocus: true,
                                 decoration: const InputDecoration(hintText: 'Enter skill name'),
                                 onChanged: (val) => skill = val,
                               ),
                               actions: [
                                 TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                 FilledButton(
                                   onPressed: () => Navigator.pop(context, skill),
                                   child: const Text('Add'),
                                 ),
                               ],
                             );
                           }
                         );
                         
                         if (newSkill != null && newSkill.isNotEmpty) {
                           notifier.addSkill(newSkill);
                         }
                       },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Experience 
                const _SectionHeader(title: 'EXPERIENCE'),
                if (cvData.userProfile.experience.isEmpty)
                   const Text('No experience listed.'),
                ...cvData.userProfile.experience.map((exp) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${exp.jobTitle} at ${exp.companyName}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '${exp.startDate} - ${exp.endDate ?? "Present"}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      AIEditableText(
                        initialText: exp.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onSave: (val) {
                           // Update specific experience description
                           // This requires smarter updates in notifier
                           notifier.updateExperience(exp, val);
                        },
                        onRewrite: (val) => repo.rewriteContent(val),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: 24),

                // Education
                const _SectionHeader(title: 'EDUCATION'),
                 if (cvData.userProfile.education.isEmpty)
                   const Text('No education listed.'),
                 ...cvData.userProfile.education.map((edu) => Padding(
                   padding: const EdgeInsets.only(bottom: 8.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(edu.schoolName, style: const TextStyle(fontWeight: FontWeight.bold)),
                       Text('${edu.degree} (${edu.startDate} - ${edu.endDate ?? "Present"})'),
                     ],
                   ),
                 )),

              ],
            ),
          );
        },
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

