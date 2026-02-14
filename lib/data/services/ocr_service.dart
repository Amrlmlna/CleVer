import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';

class OCRService {
  final _textRecognizer = TextRecognizer();
  final _imagePicker = ImagePicker();

  /// Extract text from an image using ML Kit
  Future<String?> extractTextFromImage(ImageSource source) async {
    try {
      print('[OCRService] Starting image picker with source: $source');
      
      // Pick image from camera or gallery
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85, // Good balance between quality and speed
      );
      
      print('[OCRService] Image picker result: ${image?.path ?? "null (cancelled)"}');
      
      if (image == null) {
        print('[OCRService] User cancelled image selection');
        return null; // User cancelled
      }

      print('[OCRService] Processing image with ML Kit...');
      
      // Perform OCR using ML Kit
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      print('[OCRService] OCR completed. Text length: ${recognizedText.text.length}');
      
      return recognizedText.text.trim();
    } catch (e) {
      print('[OCRService] Error extracting text: $e');
      return null;
    }
  }

  /// Extract text from PDF file
  Future<String?> extractTextFromPDF() async {
    try {
      print('[OCRService] Starting PDF picker...');
      
      // Pick PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      
      if (result == null || result.files.single.path == null) {
        print('[OCRService] User cancelled PDF selection');
        return null; // User cancelled
      }
      
      final file = File(result.files.single.path!);
      print('[OCRService] Processing PDF: ${file.path}');
      
      // Try extracting text from PDF
      PDFDoc doc = await PDFDoc.fromFile(file);
      String text = await doc.text;
      
      if (text.trim().isNotEmpty) {
        print('[OCRService] PDF text extracted successfully. Length: ${text.length}');
        return text.trim(); // ✅ PDF has selectable text
      }
      
      print('[OCRService] No text found in PDF (might be scanned)');
      return null; // Scanned PDF - would need image conversion
      
    } catch (e) {
      print('[OCRService] PDF extraction error: $e');
      return null;
    }
  }

  /// Clean up resources
  void dispose() {
    _textRecognizer.close();
  }
}
