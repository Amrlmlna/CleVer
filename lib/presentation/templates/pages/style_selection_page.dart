import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../cv/providers/cv_download_provider.dart';
import '../../drafts/providers/draft_provider.dart';
import '../providers/template_provider.dart';
import '../widgets/style_selection_content.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../../../../core/services/payment_service.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../auth/utils/auth_guard.dart';

import 'package:clever/l10n/generated/app_localizations.dart';

class StyleSelectionPage extends ConsumerStatefulWidget {
  const StyleSelectionPage({super.key});

  @override
  ConsumerState<StyleSelectionPage> createState() => _StyleSelectionPageState();
}

class _StyleSelectionPageState extends ConsumerState<StyleSelectionPage> {

  Future<void> _exportPDF() async {
    final creationState = ref.read(cvCreationProvider);
    
    if (creationState.jobInput == null || creationState.userProfile == null || creationState.summary == null) {
      CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.incompleteData);
      return;
    }

    final selectedStyleId = creationState.selectedStyle;

    await ref.read(cvDownloadProvider.notifier).attemptDownload(
      context: context,
      styleId: selectedStyleId,
    );
  }

  Future<void> _handleStyleSelection(String styleId) async {
    final templates = ref.read(templatesProvider).value ?? [];
    final template = templates.firstWhere((t) => t.id == styleId);

    if (template.isLocked) {
      if (mounted) {
        if (!AuthGuard.check(context, featureTitle: AppLocalizations.of(context)!.authWallSelectTemplate, featureDescription: AppLocalizations.of(context)!.authWallSelectTemplateDesc)) return;
        
        final purchased = await PaymentService.presentPaywall();
        if (purchased) {
          ref.invalidate(templatesProvider);
        }
      }
      return;
    }

    ref.read(cvCreationProvider.notifier).setStyle(styleId);

    await ref.read(draftsProvider.notifier).saveFromState(ref.read(cvCreationProvider));
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(templatesProvider);
    final downloadState = ref.watch(cvDownloadProvider);
    
    return templatesAsync.when(
      data: (templates) {
        final creationState = ref.watch(cvCreationProvider);
        final selectedStyle = creationState.selectedStyle;
        
        if (templates.isNotEmpty && !templates.any((t) => t.id == selectedStyle)) {
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
            if (downloadState.status == DownloadStatus.generating || downloadState.status == DownloadStatus.loading)
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
