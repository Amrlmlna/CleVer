import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/pdf_generator.dart';
import '../../../core/services/mock_ad_service.dart';
import '../providers/cv_generation_provider.dart';
import '../../drafts/providers/draft_provider.dart';
import '../widgets/preview/preview_header.dart';
import '../widgets/preview/preview_summary.dart';
import '../widgets/preview/preview_skills.dart';
import '../widgets/preview/preview_experience.dart';
import '../widgets/preview/preview_education.dart';

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
          title: const Text('CV Preview'),
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
              onPressed: () async {
                 // Trigger Interstitial Ad
                 await MockAdService.showInterstitialAd(context);
                 
                 // Proceed to Export
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
                PreviewHeader(userProfile: cvData.userProfile),
                const Divider(height: 32, thickness: 1.5),

                // Summary
                PreviewSummary(
                  summary: cvData.generatedSummary,
                  onSave: (val) => notifier.updateSummary(val),
                  onRewrite: (val) => repo.rewriteContent(val),
                ),
                const SizedBox(height: 24),

                // Skills
                PreviewSkills(
                  skills: cvData.tailoredSkills,
                  onAddSkill: (skill) => notifier.addSkill(skill),
                ),
                const SizedBox(height: 24),

                // Experience 
                PreviewExperience(
                  experience: cvData.userProfile.experience,
                  onUpdateDescription: (exp, val) => notifier.updateExperience(exp, val),
                  onRewrite: (val) => repo.rewriteContent(val),
                ),
                const SizedBox(height: 24),

                // Education
                PreviewEducation(education: cvData.userProfile.education),
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
