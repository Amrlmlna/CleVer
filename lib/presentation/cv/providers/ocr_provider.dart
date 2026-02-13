import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/ocr_service.dart';
import '../../../data/repositories/job_extraction_repository.dart';
import '../../../domain/entities/job_input.dart';

/// OCR State
class OCRState {
  final bool isLoading;
  final JobInput? extractedData;
  final String? error;

  const OCRState({
    this.isLoading = false,
    this.extractedData,
    this.error,
  });

  OCRState copyWith({
    bool? isLoading,
    JobInput? extractedData,
    String? error,
  }) {
    return OCRState(
      isLoading: isLoading ?? this.isLoading,
      extractedData: extractedData ?? this.extractedData,
      error: error,
    );
  }
}

/// OCR Notifier
class OCRNotifier extends Notifier<OCRState> {
  late final OCRService _ocrService;
  late final JobExtractionRepository _repository;

  @override
  OCRState build() {
    _ocrService = OCRService();
    _repository = JobExtractionRepository();
    return const OCRState();
  }

  /// Scan job posting from image source
  Future<JobInput?> scanJobPosting(ImageSource source) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Step 1: Extract text from image using OCR (on-device)
      final text = await _ocrService.extractTextFromImage(source);

      if (text == null || text.isEmpty) {
        throw Exception('No text found in image');
      }

      // Step 2: Send text to backend for parsing
      final jobInput = await _repository.extractFromText(text);

      // Update state with success
      state = state.copyWith(
        isLoading: false,
        extractedData: jobInput,
        error: null,
      );

      return jobInput;
    } catch (e) {
      // Update state with error
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Reset state
  void reset() {
    state = const OCRState();
    _ocrService.dispose();
  }
}

/// OCR Provider
final ocrProvider = NotifierProvider<OCRNotifier, OCRState>(OCRNotifier.new);
