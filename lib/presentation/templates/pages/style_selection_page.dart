import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../cv/providers/cv_download_provider.dart';
import '../widgets/style_selection_content.dart';
import '../../common/widgets/app_loading_screen.dart';

import '../../../../core/router/app_routes.dart';

import 'package:clever/l10n/generated/app_localizations.dart';

class StyleSelectionPage extends ConsumerWidget {
  const StyleSelectionPage({super.key});

  Future<void> _navigateToPreview(BuildContext context) async {
    context.push(AppRoutes.createTemplatePreview);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadState = ref.watch(cvDownloadProvider);

    return Stack(
      children: [
        StyleSelectionContent(onExport: () => _navigateToPreview(context)),
        if (downloadState.status == DownloadStatus.generating ||
            downloadState.status == DownloadStatus.loading)
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
  }
}
