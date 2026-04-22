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
      debugPrint('[OCRDataSource] Starting image picker with source: $source');

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

  Future<String?> extractTextFromPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) return null;

      final file = File(result.files.single.path!);
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

  void dispose() {
    _textRecognizer.close();
  }
}
