import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/datasources/ocr_datasource.dart';
import '../../../data/datasources/remote_job_datasource.dart';
import '../../../data/repositories/job_extraction_repository.dart';
import '../../../domain/entities/job_input.dart';

final remoteJobDataSourceProvider = Provider<RemoteJobDataSource>((ref) {
  return RemoteJobDataSource();
});

final jobExtractionRepositoryProvider = Provider<JobExtractionRepository>((ref) {
  final dataSource = ref.watch(remoteJobDataSourceProvider);
  return JobExtractionRepository(remoteDataSource: dataSource);
});

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

class OCRNotifier extends Notifier<OCRState> {
  late final OCRDataSource _ocrService;
  late final JobExtractionRepository _repository;

  @override
  OCRState build() {
    _ocrService = OCRDataSource();
    _repository = ref.watch(jobExtractionRepositoryProvider);
    return const OCRState();
  }

  Future<OCRResult> scanJobPosting(
    ImageSource source, {
    VoidCallback? onProcessingStart,
  }) async {
    final extractedText = await _pickAndExtractText(source);
    
    if (extractedText == null) {
      return OCRResult.cancelled();
    }
    
    if (extractedText.isEmpty) {
      return OCRResult.noText();
    }

    onProcessingStart?.call();

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

  Future<String?> _pickAndExtractText(ImageSource source) async {
    try {
      final text = await _ocrService.extractTextFromImage(source);
      return text;
    } catch (e) {
      return null;
    }
  }

  void reset() {
    state = const OCRState();
    _ocrService.dispose();
  }
}

final ocrProvider = NotifierProvider<OCRNotifier, OCRState>(OCRNotifier.new);
