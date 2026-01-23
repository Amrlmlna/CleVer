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

  Future<void> _saveDraft(BuildContext context, WidgetRef ref) async {
    final currentData = ref.read(generatedCVProvider).asData?.value;
    if (currentData != null) {
      await ref.read(draftsProvider.notifier).saveDraft(currentData);
      ref.read(unsavedChangesProvider.notifier).state = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Draft Disimpan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cvAsyncValue = ref.watch(generatedCVProvider);
    final hasUnsavedChanges = ref.watch(unsavedChangesProvider);

    // Auto-Save Effect
    ref.listen(generatedCVProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        // Only auto-save if it's the *first* load (previous was loading/null) OR explicitly requested?
        // Actually, "auto-save generated CV" usually means "save the initial result".
        // But we must be careful not to save endlessly on every keystroke if we were treating this as a true "auto-save" for edits.
        // For now, let's save when we transition from loading -> data (Generation Complete).
        
        final isGenerationComplete = (previous is AsyncLoading) && (next is AsyncData);
        if (isGenerationComplete) {
           // We use a microtask or post-frame callback to avoid build-phase side effects,
           // but reading notifier in listen is generally safe.
           // However, saveDraft is async and modifies state.
           Future(() {
             ref.read(draftsProvider.notifier).saveDraft(next.value!);
           });
        }
      }
    });

    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ada perubahan yang belum disimpan'),
            content: const Text('Kamu punya perubahan yang belum disimpan. Mau disimpan dulu sebelum keluar?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  // Discard
                  ref.read(unsavedChangesProvider.notifier).state = false;
                  Navigator.of(context).pop(true);
                },
                child: const Text('Buang', style: TextStyle(color: Colors.red)),
              ),
              FilledButton(
                onPressed: () async {
                  await _saveDraft(context, ref);
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: const Text('Simpan & Keluar'),
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
          title: const Text('Preview CV'),
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
               onPressed: () => _saveDraft(context, ref),
              child: const Text('Simpan'),
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
              child: const Text('Ekspor PDF'),
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
                  onRewrite: (val) => repo.rewriteContent(val, cvData.language),
                  language: cvData.language,
                ),
                const SizedBox(height: 24),

                // Skills
                PreviewSkills(
                  skills: cvData.tailoredSkills,
                  onAddSkill: (skill) => notifier.addSkill(skill),
                  language: cvData.language,
                ),
                const SizedBox(height: 24),

                // Experience 
                PreviewExperience(
                  experience: cvData.userProfile.experience,
                  onUpdateDescription: (exp, val) => notifier.updateExperience(exp, val),
                  onRewrite: (val) => repo.rewriteContent(val, cvData.language),
                  language: cvData.language,
                ),
                const SizedBox(height: 24),

                // Education
                PreviewEducation(
                  education: cvData.userProfile.education,
                  language: cvData.language,
                ),
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
              Text('AI lagi meracik CV kamu...'),
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
