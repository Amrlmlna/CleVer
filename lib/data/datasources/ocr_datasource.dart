import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/foundation.dart';

class OCRDataSource {
  final _textRecognizer = TextRecognizer();
  final _imagePicker = ImagePicker();

  Future<String?> extractTextFromImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          imageQuality: 85,
        );
        if (images.isEmpty) return null;
        final texts = await Future.wait(
          images.map((img) => extractTextFromFilePath(img.path)),
        );
        final combined = texts.where((t) => t != null && t.isNotEmpty).join('\n\n');
        return combined.isNotEmpty ? combined : '';
      }

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (image == null) return null;
      return extractTextFromFilePath(image.path);
    } catch (e) {
      debugPrint('[OCRDataSource] Error extracting text: $e');
      return null;
    }
  }

  Future<String?> extractTextFromFilePath(String path) async {
    try {
      final inputImage = InputImage.fromFilePath(path);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text.trim();
    } catch (e) {
      debugPrint('[OCRDataSource] Error processing image path: $e');
      return null;
    }
  }

  Future<List<File>?> pickPDFFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result == null || result.paths.isEmpty) return null;
      return result.paths.whereType<String>().map((p) => File(p)).toList();
    } catch (e) {
      debugPrint('[OCRDataSource] PDF picking error: $e');
      return null;
    }
  }

  Future<File?> pickPDFFile() async {
    final files = await pickPDFFiles();
    return (files != null && files.isNotEmpty) ? files.first : null;
  }

  Future<String?> extractTextFromPDFFile(File file) async {
    try {
      final PdfDocument document = PdfDocument(
        inputBytes: file.readAsBytesSync(),
      );

      String extractedText = PdfTextExtractor(document).extractText();
      document.dispose();

      return extractedText.trim().isNotEmpty ? extractedText.trim() : null;
    } catch (e) {
      debugPrint('[OCRDataSource] PDF extraction error: $e');
      return null;
    }
  }

  Future<String?> extractTextFromPDF() async {
    final files = await pickPDFFiles();
    if (files == null || files.isEmpty) return null;
    final results = await Future.wait(files.map((f) => extractTextFromPDFFile(f)));
    final combined = results.where((t) => t != null && t.isNotEmpty).join('\n\n');
    return combined.isNotEmpty ? combined : '';
  }

  void dispose() {
    _textRecognizer.close();
  }
}
