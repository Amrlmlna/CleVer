import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/entities/cv_data.dart';
import '../../../../core/utils/pdf_generator.dart';
import '../../../../core/services/mock_ad_service.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../drafts/providers/draft_provider.dart';
import '../providers/template_provider.dart';
import '../widgets/style_selection_content.dart';

class StyleSelectionPage extends ConsumerStatefulWidget {
  const StyleSelectionPage({super.key});

  @override
  ConsumerState<StyleSelectionPage> createState() => _StyleSelectionPageState();
}

class _StyleSelectionPageState extends ConsumerState<StyleSelectionPage> {
  String _selectedStyle = 'Modern';

  Future<void> _exportPDF() async {
    final creationState = ref.read(cvCreationProvider);
    
    // Validate Data
    if (creationState.jobInput == null || creationState.userProfile == null || creationState.summary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data tidak lengkap. Kembali ke form sebelumnya.')),
      );
      return;
    }

    // Set Style
    ref.read(cvCreationProvider.notifier).setStyle(_selectedStyle);

    // Save Draft (optional, but good for history)
    final cvData = CVData(
      id: const Uuid().v4(),
      userProfile: creationState.userProfile!,
      summary: creationState.summary!,
      styleId: _selectedStyle,
      createdAt: DateTime.now(),
      jobTitle: creationState.jobInput!.jobTitle,
      language: creationState.language,
    );
    
    // Auto-save to drafts
    await ref.read(draftsProvider.notifier).saveDraft(cvData);

    if (mounted) {
       // Trigger Ad
       await MockAdService.showInterstitialAd(context);
       
       // Generate PDF
       await PDFGenerator.generateAndPrint(cvData);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get templates from provider
    final templates = ref.watch(templateRepositoryProvider).getAllTemplates();
    final currentLanguage = ref.watch(cvCreationProvider).language;
    
    return StyleSelectionContent(
      templates: templates,
      selectedStyleId: _selectedStyle,
      selectedLanguage: currentLanguage,
      onStyleSelected: (styleId) {
        setState(() {
          _selectedStyle = styleId;
        });
      },
      onLanguageChanged: (lang) {
        ref.read(cvCreationProvider.notifier).setLanguage(lang);
      },
      onExport: _exportPDF,
    );
  }
}
