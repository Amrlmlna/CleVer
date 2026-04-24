import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdfx/pdfx.dart';
import '../../../domain/entities/completed_cv.dart';
import '../../presentation/drafts/providers/completed_cv_provider.dart';

class PDFExportService {
  static Future<CompletedCV> finalizeExport({
    required List<int> pdfBytes,
    required String cvId,
    required String jobTitle,
    required String styleId,
  }) async {
    if (pdfBytes.length < 1000) {
      throw Exception(
        'Downloaded PDF is too small (${pdfBytes.length} bytes).',
      );
    }

    final cvDir = await CompletedCVNotifier.getStorageDir();
    final safeId = styleId
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        .toLowerCase();
    final fileName =
        'cv_${safeId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final pdfFile = File('${cvDir.path}/$fileName');
    await pdfFile.writeAsBytes(pdfBytes, flush: true);

    String? thumbnailPath;
    try {
      final thumbDir = await CompletedCVNotifier.getThumbnailDir();
      final thumbFile = File('${thumbDir.path}/${cvId}_thumb.png');

      final document = await PdfDocument.openData(Uint8List.fromList(pdfBytes));
      final page = await document.getPage(1);
      final pageImage = await page.render(
        width: page.width * 0.5,
        height: page.height * 0.5,
        format: PdfPageImageFormat.png,
        backgroundColor: '#FFFFFF',
      );

      if (pageImage != null) {
        await thumbFile.writeAsBytes(pageImage.bytes);
        thumbnailPath = thumbFile.path;
      }

      await page.close();
      await document.close();
    } catch (e) {
      debugPrint('Thumbnail generation failed: $e');
    }

    return CompletedCV(
      id: cvId,
      jobTitle: jobTitle,
      templateId: styleId,
      pdfPath: pdfFile.path,
      thumbnailPath: thumbnailPath,
      generatedAt: DateTime.now(),
    );
  }
}
