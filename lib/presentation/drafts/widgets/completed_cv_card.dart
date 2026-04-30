import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:clever/core/utils/custom_snackbar.dart';
import '../../../domain/entities/completed_cv.dart';
import '../providers/completed_cv_provider.dart';
import 'download_confirmation_dialog.dart';

class CompletedCVCard extends ConsumerWidget {
  final CompletedCV cv;

  const CompletedCVCard({super.key, required this.cv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDownloading = ref.watch(downloadingCVsProvider).contains(cv.id);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _handleTap(context, ref),
        onLongPress: () => _showOptions(context, ref),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: _buildThumbnail(context)),
                    if (isDownloading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.4),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.finalStatus.toUpperCase(),
                          style: TextStyle(
                            color: colorScheme.surface,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (cv.jobTitle.isNotEmpty ? cv.jobTitle : l10n.untitled)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeago.format(cv.generatedAt).toUpperCase(),
                      style: TextStyle(
                        fontSize: 8,
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cv.templateId.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_outward_rounded,
                            color: colorScheme.surface,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    if (cv.thumbnailPath != null) {
      final file = File(cv.thumbnailPath!);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholderThumbnail(context),
        );
      }
    }
    return _placeholderThumbnail(context);
  }

  Widget _placeholderThumbnail(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isCloudOnly =
        !File(cv.pdfPath).existsSync() && cv.remotePdfUrl != null;

    return Container(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Center(
        child: Icon(
          isCloudOnly
              ? Icons.cloud_download_outlined
              : Icons.picture_as_pdf_rounded,
          size: 36,
          color: isCloudOnly
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final file = File(cv.pdfPath);

    if (await file.exists()) {
      await OpenFilex.open(cv.pdfPath);
    } else if (cv.remotePdfUrl != null) {
      final shouldDownload = await showDialog<bool>(
        context: context,
        builder: (context) => const DownloadConfirmationDialog(),
      );

      if (shouldDownload == true) {
        try {
          await ref.read(completedCVProvider.notifier).downloadCVFile(cv, ref);
          if (context.mounted) {
            CustomSnackBar.showSuccess(
              context,
              l10n.downloadComplete.toUpperCase(),
            );
          }
        } catch (e) {
          if (context.mounted) {
            CustomSnackBar.showError(
              context,
              l10n.downloadFailed(e.toString().toUpperCase()).toUpperCase(),
            );
          }
        }
      }
    }
  }

  void _openPDF() async {
    final file = File(cv.pdfPath);
    if (await file.exists()) {
      await OpenFilex.open(cv.pdfPath);
    }
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.open_in_new, color: colorScheme.onSurface),
                title: Text(
                  l10n.openPDF,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openPDF();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: colorScheme.error),
                title: Text(
                  l10n.delete,
                  style: TextStyle(color: colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(completedCVProvider.notifier)
                      .deleteCompletedCV(cv.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
