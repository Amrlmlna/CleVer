import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../domain/entities/cv_data.dart';
import '../../../../core/services/mock_ad_service.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../drafts/providers/draft_provider.dart';
import '../providers/template_provider.dart';
import '../widgets/style_selection_content.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../../../../core/services/payment_service.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class StyleSelectionPage extends ConsumerStatefulWidget {
  const StyleSelectionPage({super.key});

  @override
  ConsumerState<StyleSelectionPage> createState() => _StyleSelectionPageState();
}

class _StyleSelectionPageState extends ConsumerState<StyleSelectionPage> {
  bool _isGenerating = false;

  Future<void> _exportPDF() async {
    final creationState = ref.read(cvCreationProvider);
    
    // Validate Data
    if (creationState.jobInput == null || creationState.userProfile == null || creationState.summary == null) {
      CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.incompleteData);
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final selectedStyle = ref.read(cvCreationProvider).selectedStyle;

      // Save Draft using provider logic
      await ref.read(draftsProvider.notifier).saveFromState(ref.read(cvCreationProvider));
      
      if (mounted) {
         // Get the draft's data (or construct it for the PDF call)
         final creationState = ref.read(cvCreationProvider);
         final cvData = CVData(
            id: const Uuid().v4(), // PDF needs an ID, but we already saved to repository
            userProfile: creationState.userProfile!,
            summary: creationState.summary!,
            styleId: selectedStyle,
            createdAt: DateTime.now(),
            jobTitle: creationState.jobInput!.jobTitle,
            jobDescription: creationState.jobInput!.jobDescription ?? '',
         );
         // Trigger Ad
         await MockAdService.showInterstitialAd(context);
         
         // Generate PDF from Backend
         final pdfBytes = await ref.read(cvRepositoryProvider).downloadPDF(
           cvData: cvData,
           templateId: selectedStyle,
         );

         // Save to Temp File
         final output = await getTemporaryDirectory();
         final file = File('${output.path}/cv_${selectedStyle.toLowerCase()}.pdf');
         await file.writeAsBytes(pdfBytes);

         // Open File
         final result = await OpenFilex.open(file.path);
         
         // Invalidate templates to refresh usage count/locked status
         ref.invalidate(templatesProvider);
         
         if (result.type != ResultType.done) {
            if (mounted) {
              CustomSnackBar.showError(context, AppLocalizations.of(context)!.pdfOpenError(result.message));
            }
         }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, AppLocalizations.of(context)!.pdfGenerateError(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _handleStyleSelection(String styleId) async {
    final templates = ref.read(templatesProvider).value ?? [];
    final template = templates.firstWhere((t) => t.id == styleId);

    if (template.isLocked) {
      if (mounted) {
        final purchased = await PaymentService.presentPaywall();
        if (purchased) {
          ref.invalidate(templatesProvider);
        }
      }
      return;
    }

    // 1. Update State in Provider
    ref.read(cvCreationProvider.notifier).setStyle(styleId);

    // 2. Implicitly Save Draft to sync choice to cloud/local
    await ref.read(draftsProvider.notifier).saveFromState(ref.read(cvCreationProvider));
  }

  @override
  Widget build(BuildContext context) {
    // Get templates asynchronously
    final templatesAsync = ref.watch(templatesProvider);
    
    return templatesAsync.when(
      data: (templates) {
        final creationState = ref.watch(cvCreationProvider);
        final selectedStyle = creationState.selectedStyle;
        
        // Ensure selected style exists in fetched templates
        if (templates.isNotEmpty && !templates.any((t) => t.id == selectedStyle)) {
             // Defer state update to next frame to avoid build error
             WidgetsBinding.instance.addPostFrameCallback((_) {
                 ref.read(cvCreationProvider.notifier).setStyle(templates.first.id);
             });
        }

        return Stack(
          children: [
            StyleSelectionContent(
              templates: templates,
              selectedStyleId: selectedStyle,
              onStyleSelected: _handleStyleSelection,
              onExport: _exportPDF,
            ),
            if (_isGenerating)
               AppLoadingScreen(
                 badge: AppLocalizations.of(context)!.generatingPdfBadge,
                 messages: [
                   AppLocalizations.of(context)!.processingData,
                   AppLocalizations.of(context)!.applyingDesign,
                   AppLocalizations.of(context)!.creatingPages,
                   AppLocalizations.of(context)!.finalizingPdf,
                 ],
               ),
          ],
        );
      },
      loading: () => AppLoadingScreen(
        badge: AppLocalizations.of(context)!.loadingTemplatesBadge,
        messages: [
          AppLocalizations.of(context)!.fetchingTemplates,
          AppLocalizations.of(context)!.preparingGallery,
          AppLocalizations.of(context)!.loadingPreview,
        ],
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Icon(Icons.error_outline, size: 48, color: Colors.red),
               const SizedBox(height: 16),
               Text(AppLocalizations.of(context)!.templateLoadError(err.toString())),
               ElevatedButton(
                 onPressed: () => ref.refresh(templatesProvider),
                 child: Text(AppLocalizations.of(context)!.retry),
               )
             ]
          ),
        ),
      ),
    );
  }
}
