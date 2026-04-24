import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../../wallet/widgets/credit_purchase_bottom_sheet.dart';
import './template_grid_item.dart';
import '../providers/template_selection_controller.dart';

class StyleSelectionContent extends ConsumerWidget {
  final VoidCallback onExport;

  const StyleSelectionContent({super.key, required this.onExport});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templateSelectionControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return AppLoadingScreen(
        badge: AppLocalizations.of(context)!.loadingTemplatesBadge,
        messages: [
          AppLocalizations.of(context)!.fetchingTemplates,
          AppLocalizations.of(context)!.preparingGallery,
          AppLocalizations.of(context)!.loadingPreview,
        ],
      );
    }

    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    final templates = state.templates;
    final selectedStyleId = state.selectedStyleId;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.selectTemplate,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: [
          if (templates.isNotEmpty)
            _CreditBadge(credits: templates.first.userCredits),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 20,
                mainAxisSpacing: 24,
              ),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return TemplateGridItem(
                  template: template,
                  isSelected: template.id == selectedStyleId,
                  onTap: () {
                    if (template.isLocked) {
                      CreditPurchaseBottomSheet.show(context);
                    } else {
                      ref
                          .read(templateSelectionControllerProvider.notifier)
                          .selectStyle(template.id);
                    }
                  },
                );
              },
            ),
          ),
          _BottomExportButton(
            onPressed: onExport,
            label: AppLocalizations.of(context)!.previewTemplate,
          ),
        ],
      ),
    );
  }
}

class _CreditBadge extends StatelessWidget {
  final int credits;

  const _CreditBadge({required this.credits});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.stars_rounded, size: 14, color: colorScheme.onSurface),
              const SizedBox(width: 4),
              Text(
                '$credits',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomExportButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const _BottomExportButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              label,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
