import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cv/providers/cv_generation_provider.dart';
import '../../cv/providers/cv_download_provider.dart';
import '../../wallet/widgets/credit_purchase_bottom_sheet.dart';
import '../providers/template_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../../core/services/payment_service.dart';
import '../../auth/utils/auth_guard.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import '../widgets/template_carousel_preview.dart';
import '../widgets/language_selector.dart';
import '../widgets/photo_toggle_settings.dart';
import '../../common/widgets/spinning_text_loader.dart';
import '../../common/widgets/swipe_to_confirm_button.dart';

class TemplatePreviewPage extends ConsumerStatefulWidget {
  const TemplatePreviewPage({super.key});

  @override
  ConsumerState<TemplatePreviewPage> createState() =>
      _TemplatePreviewPageState();
}

class _TemplatePreviewPageState extends ConsumerState<TemplatePreviewPage>
    with WidgetsBindingObserver {
  String? _manualLocaleOverride;
  bool _usePhoto = true;
  bool _isUploading = false;
  bool _isWaitingForPaywall = false;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isWaitingForPaywall) {
      _isWaitingForPaywall = false;
      if (mounted) {
        CreditPurchaseBottomSheet.show(context);
      }
    }
  }

  Future<void> _handleDownload() async {
    final creationState = ref.read(cvCreationProvider);
    final selectedStyleId = creationState.selectedStyle;
    final templates = ref.read(templatesProvider).value ?? [];
    final template = templates.firstWhere(
      (t) => t.id == selectedStyleId,
      orElse: () => templates.first,
    );

    if (template.isLocked) {
      if (mounted) {
        if (!AuthGuard.check(
          context,
          featureTitle: AppLocalizations.of(context)!.authWallBuyCredits,
          featureDescription: AppLocalizations.of(
            context,
          )!.authWallBuyCreditsDesc,
        ))
          return;

        final purchased = await PaymentService.presentPaywall(context);
        if (purchased) {
          ref.invalidate(templatesProvider);
        }
      }
      return;
    }

    final globalLocale = ref.read(localeNotifierProvider).languageCode;
    final effectiveLocale = _manualLocaleOverride ?? globalLocale;

    await ref
        .read(cvDownloadProvider.notifier)
        .attemptDownload(
          context: context,
          styleId: selectedStyleId,
          locale: effectiveLocale,
          usePhoto: _usePhoto,
          onSuccess: () async {
            if (mounted) {
              setState(() {
                _isWaitingForPaywall = true;
              });
              // Set the success flag for ReviewService to pick up later on HomePage
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('has_generated_at_least_one_cv', true);
            }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(templatesProvider);
    final creationState = ref.watch(cvCreationProvider);
    final downloadState = ref.watch(cvDownloadProvider);
    final photoUrl = ref
        .watch(profileControllerProvider)
        .currentProfile
        .photoUrl;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.previewCV),
        centerTitle: true,
      ),
      body: templatesAsync.when(
        data: (templates) {
          final template = templates.firstWhere(
            (t) => t.id == creationState.selectedStyle,
            orElse: () => templates.isNotEmpty
                ? templates.first
                : throw Exception('No template selected'),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TemplateCarouselPreview(
                  previewUrls: template.previewUrls,
                  thumbnailUrl: template.thumbnailUrl,
                  supportsPhoto: template.supportsPhoto,
                  usePhoto: _usePhoto,
                  pageController: _pageController,
                  onPageChanged: (index) {
                    if (template.supportsPhoto &&
                        template.previewUrls.length > 1) {
                      setState(() => _usePhoto = (index == 1));
                    }
                  },
                ),
                const SizedBox(height: 32),

                Text(
                  AppLocalizations.of(context)!.cvLanguage,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                LanguageSelector(
                  manualLocaleOverride: _manualLocaleOverride,
                  onLocaleChanged: (code) =>
                      setState(() => _manualLocaleOverride = code),
                ),
                const SizedBox(height: 24),

                if (template.supportsPhoto) ...[
                  Text(
                    AppLocalizations.of(context)!.photoSettings,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  PhotoToggleSettings(
                    photoUrl: photoUrl,
                    usePhoto: _usePhoto,
                    onUploadingChanged: (val) =>
                        setState(() => _isUploading = val),
                    onToggleChanged: (val) {
                      setState(() => _usePhoto = val);
                      if (template.supportsPhoto &&
                          template.previewUrls.length > 1) {
                        _pageController.animateToPage(
                          val ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
                const SizedBox(height: 100),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.templateLoadError(err.toString()),
              ),
              ElevatedButton(
                onPressed: () => ref.refresh(templatesProvider),
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: SwipeToConfirmButton(
              isLoading:
                  downloadState.status == DownloadStatus.generating ||
                  _isUploading,
              onConfirm: _handleDownload,
              child: downloadState.status == DownloadStatus.generating
                  ? SpinningTextLoader(
                      texts: [
                        AppLocalizations.of(
                          context,
                        )!.generatingPdfBadge.toUpperCase(),
                        AppLocalizations.of(
                          context,
                        )!.processingData.toUpperCase(),
                        AppLocalizations.of(
                          context,
                        )!.finalizingPdf.toUpperCase(),
                      ],
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                        fontSize: 13,
                      ),
                    )
                  : Builder(
                      builder: (context) {
                        final currentTemplates =
                            ref.watch(templatesProvider).valueOrNull ?? [];
                        if (currentTemplates.isEmpty) {
                          return Text(
                            AppLocalizations.of(
                              context,
                            )!.exportPdf.toUpperCase(),
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.0,
                              fontSize: 13,
                            ),
                          );
                        }
                        final currentTemplate = currentTemplates.firstWhere(
                          (t) =>
                              t.id ==
                              ref.watch(cvCreationProvider).selectedStyle,
                          orElse: () => currentTemplates.first,
                        );

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentTemplate.hasFreeGeneration
                                      ? AppLocalizations.of(
                                          context,
                                        )!.generateCvFree.toUpperCase()
                                      : AppLocalizations.of(context)!
                                            .generateCvCost(
                                              0,
                                            ) // We only use this for baseline translation, bypassing the cost parser safely as it was removed from the arb payload.
                                            .replaceAll(
                                              RegExp(r'\s*\(.*?\)'),
                                              '',
                                            )
                                            .toUpperCase(),
                                  style: textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.0,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.05,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    currentTemplate.hasFreeGeneration
                                        ? "FREE"
                                        : "${currentTemplate.requiredCredits} CREDITS",
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (currentTemplate.hasFreeGeneration)
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  AppLocalizations.of(context)!.freeExportsLeft(
                                    2 - currentTemplate.currentUsage,
                                  ),
                                  style: textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurfaceVariant,
                                    letterSpacing: 0.5,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
