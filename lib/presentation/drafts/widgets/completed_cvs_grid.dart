import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../domain/entities/completed_cv.dart';
import '../providers/completed_cv_provider.dart';

class CompletedCVsGrid extends ConsumerWidget {
  const CompletedCVsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAsync = ref.watch(completedCVProvider);

    return completedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (cvs) {
        if (cvs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.picture_as_pdf_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noCompletedCVs,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.generateCVFirst,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.only(top: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemCount: cvs.length,
          itemBuilder: (context, index) {
            return _CompletedCVCard(cv: cvs[index]);
          },
        );
      },
    );
  }
}

class _CompletedCVCard extends ConsumerWidget {
  final CompletedCV cv;

  const _CompletedCVCard({required this.cv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _handleTap(context, ref),
      onLongPress: () => _showOptions(context, ref),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(13),
                ),
                child: _buildThumbnail(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cv.jobTitle.isNotEmpty ? cv.jobTitle : 'Untitled',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          cv.templateId,
                          style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        timeago.format(cv.generatedAt),
                        style: TextStyle(
                          fontSize: 9,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    if (cv.thumbnailPath != null) {
      final file = File(cv.thumbnailPath!);
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderThumbnail(context),
      );
    }
    return _placeholderThumbnail(context);
  }

  Widget _placeholderThumbnail(BuildContext context) {
    final bool isCloudOnly =
        !File(cv.pdfPath).existsSync() && cv.remotePdfUrl != null;

    return Container(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Center(
        child: Icon(
          isCloudOnly
              ? Icons.cloud_download_outlined
              : Icons.picture_as_pdf_rounded,
          size: 36,
          color: isCloudOnly
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) async {
    final file = File(cv.pdfPath);
    if (await file.exists()) {
      await OpenFilex.open(cv.pdfPath);
    } else if (cv.remotePdfUrl != null) {
      // Show download confirmation
      final shouldDownload = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.downloadPDF),
          content: Text(AppLocalizations.of(context)!.downloadPDFDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.download),
            ),
          ],
        ),
      );

      if (shouldDownload == true) {
        await ref.read(completedCVProvider.notifier).downloadCVFile(cv);
      }
    }
  }

  void _openPDF(BuildContext context) async {
    final file = File(cv.pdfPath);
    if (await file.exists()) {
      await OpenFilex.open(cv.pdfPath);
    }
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
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
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  Icons.open_in_new,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text(
                  AppLocalizations.of(context)!.openPDF,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openPDF(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
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
