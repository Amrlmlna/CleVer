import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRService {
  final _textRecognizer = TextRecognizer();
  final _imagePicker = ImagePicker();

  /// Extract text from an image using ML Kit
  Future<String?> extractTextFromImage(ImageSource source) async {
    try {
      // Pick image from camera or gallery
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85, // Good balance between quality and speed
      );
      
      if (image == null) {
        return null; // User cancelled
      }

      // Perform OCR using ML Kit
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      return recognizedText.text.trim();
    } catch (e) {
      print('[OCRService] Error extracting text: $e');
      return null;
    }
  }

  /// Clean up resources
  void dispose() {
    _textRecognizer.close();
  }
}
