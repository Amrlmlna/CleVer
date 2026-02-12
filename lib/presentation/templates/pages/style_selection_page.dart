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
import '../../common/widgets/modern_loading_screen.dart';

class StyleSelectionPage extends ConsumerStatefulWidget {
  const StyleSelectionPage({super.key});

  @override
  ConsumerState<StyleSelectionPage> createState() => _StyleSelectionPageState();
}

class _StyleSelectionPageState extends ConsumerState<StyleSelectionPage> {
  String _selectedStyle = 'ATS'; // Default to ATS as it matches the first template usually
  bool _isGenerating = false;

  Future<void> _exportPDF() async {
    final creationState = ref.read(cvCreationProvider);
    
    // Validate Data
    if (creationState.jobInput == null || creationState.userProfile == null || creationState.summary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data tidak lengkap. Kembali ke form sebelumnya.')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      // Set Style
      ref.read(cvCreationProvider.notifier).setStyle(_selectedStyle);

      // Save Draft
      final cvData = CVData(
        id: const Uuid().v4(),
        userProfile: creationState.userProfile!,
        summary: creationState.summary!,
        styleId: _selectedStyle,
        createdAt: DateTime.now(),
        jobTitle: creationState.jobInput!.jobTitle,
        language: creationState.language,
      );
      
      await ref.read(draftsProvider.notifier).saveDraft(cvData);

      if (mounted) {
         // Trigger Ad
         await MockAdService.showInterstitialAd(context);
         
         // Generate PDF from Backend
         final pdfBytes = await ref.read(cvRepositoryProvider).downloadPDF(
           cvData: cvData,
           templateId: _selectedStyle,
         );

         // Save to Temp File
         final output = await getTemporaryDirectory();
         final file = File('${output.path}/cv_${_selectedStyle.toLowerCase()}.pdf');
         await file.writeAsBytes(pdfBytes);

         // Open File
         final result = await OpenFilex.open(file.path);
         if (result.type != ResultType.done) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal membuka PDF: ${result.message}')),
              );
            }
         }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat PDF: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get templates asynchronously
    final templatesAsync = ref.watch(templatesProvider);
    final currentLanguage = ref.watch(cvCreationProvider).language;
    
    return templatesAsync.when(
      data: (templates) {
        // Ensure selected style exists in fetched templates
        if (templates.isNotEmpty && !templates.any((t) => t.id == _selectedStyle)) {
             // Defer state update to next frame to avoid build error
             WidgetsBinding.instance.addPostFrameCallback((_) {
               if (mounted) {
                 setState(() {
                   _selectedStyle = templates.first.id;
                 });
               }
             });
        }

        return Stack(
          children: [
            StyleSelectionContent(
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
            ),
            if (_isGenerating)
               const ModernLoadingScreen(
                 badgeText: "GENERATING PDF",
                 loadingTexts: [
                   "Memproses Data...",
                   "Menerapkan Desain...",
                   "Membuat Halaman...",
                   "Finalisasi PDF...",
                 ],
               ),
          ],
        );
      },
      loading: () => const ModernLoadingScreen(
        badgeText: "LOADING TEMPLATES",
        loadingTexts: [
          "Mengambil Template...",
          "Menyiapkan Galeri...",
          "Memuat Preview...",
        ],
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Icon(Icons.error_outline, size: 48, color: Colors.red),
               const SizedBox(height: 16),
               Text('Error loading templates: $err'),
               ElevatedButton(
                 onPressed: () => ref.refresh(templatesProvider),
                 child: const Text('Retry'),
               )
             ]
          ),
        ),
      ),
    );
  }
}
