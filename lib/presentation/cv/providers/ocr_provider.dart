import 'package:flutter/foundation.dart';
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

/// OCR Result
enum OCRStatus { success, cancelled, noText, error }

class OCRResult {
  final OCRStatus status;
  final JobInput? jobInput;
  final String? errorMessage;

  const OCRResult({
    required this.status,
    this.jobInput,
    this.errorMessage,
  });

  factory OCRResult.success(JobInput jobInput) => OCRResult(
    status: OCRStatus.success,
    jobInput: jobInput,
  );

  factory OCRResult.cancelled() => const OCRResult(status: OCRStatus.cancelled);

  factory OCRResult.noText() => const OCRResult(status: OCRStatus.noText);

  factory OCRResult.error(String message) => OCRResult(
    status: OCRStatus.error,
    errorMessage: message,
  );
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

  /// Complete OCR flow: pick image -> extract text -> parse with backend
  /// Returns OCRResult with status and data
  /// onProcessingStart: callback fired when backend processing begins (after image is picked)
  Future<OCRResult> scanJobPosting(
    ImageSource source, {
    VoidCallback? onProcessingStart,
  }) async {
    // Step 1: Pick image and extract text (no loading state yet)
    final extractedText = await _pickAndExtractText(source);
    
    if (extractedText == null) {
      return OCRResult.cancelled();
    }
    
    if (extractedText.isEmpty) {
      return OCRResult.noText();
    }

    // Step 2: Notify UI that processing is starting (show loading screen)
    onProcessingStart?.call();

    // Step 3: Process text with backend (with loading state)
    state = state.copyWith(isLoading: true, error: null);

    try {
      final jobInput = await _repository.extractFromText(extractedText);

      state = state.copyWith(
        isLoading: false,
        extractedData: jobInput,
        error: null,
      );

      return OCRResult.success(jobInput);
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(
        isLoading: false,
        error: errorMsg,
      );
      return OCRResult.error(errorMsg);
    }
  }

  /// Private: Pick image and extract text
  Future<String?> _pickAndExtractText(ImageSource source) async {
    try {
      final text = await _ocrService.extractTextFromImage(source);
      return text;
    } catch (e) {
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
