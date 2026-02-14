import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../data/services/ocr_service.dart';
import '../../../data/repositories/cv_import_repository.dart';

enum CVImportStatus { idle, processing, success, cancelled, noText, error }

class CVImportState {
  final CVImportStatus status;
  final UserProfile? extractedProfile;
  final String? errorMessage;

  const CVImportState({
    this.status = CVImportStatus.idle,
    this.extractedProfile,
    this.errorMessage,
  });

  CVImportState copyWith({
    CVImportStatus? status,
    UserProfile? extractedProfile,
    String? errorMessage,
  }) {
    return CVImportState(
      status: status ?? this.status,
      extractedProfile: extractedProfile ?? this.extractedProfile,
      errorMessage: errorMessage,
    );
  }
}

class CVImportNotifier extends Notifier<CVImportState> {
  late OCRService _ocrService;
  late CVImportRepository _repository;

  @override
  CVImportState build() {
    _ocrService = OCRService();
    _repository = CVImportRepository();
    return const CVImportState();
  }

  /// Import CV from image (camera or gallery)
  Future<CVImportState> importFromImage(
    ImageSource source, {
    Function()? onProcessingStart,
  }) async {
    // Step 1: Extract text from image
    final cvText = await _ocrService.extractTextFromImage(source);

    if (cvText == null) {
      state = state.copyWith(status: CVImportStatus.cancelled);
      return state;
    }

    if (cvText.isEmpty) {
      state = state.copyWith(
        status: CVImportStatus.noText,
        errorMessage: 'No text found in image',
      );
      return state;
    }

    // Step 2: Notify UI that processing starts
    onProcessingStart?.call();

    // Step 3: Parse CV with backend
    state = state.copyWith(status: CVImportStatus.processing);

    try {
      final profile = await _repository.parseCV(cvText);
      state = state.copyWith(
        status: CVImportStatus.success,
        extractedProfile: profile,
      );
      return state;
    } catch (e) {
      state = state.copyWith(
        status: CVImportStatus.error,
        errorMessage: e.toString(),
      );
      return state;
    }
  }

  /// Import CV from PDF file
  Future<CVImportState> importFromPDF({
    Function()? onProcessingStart,
  }) async {
    // Step 1: Extract text from PDF
    final cvText = await _ocrService.extractTextFromPDF();

    if (cvText == null) {
      state = state.copyWith(status: CVImportStatus.cancelled);
      return state;
    }

    if (cvText.isEmpty) {
      state = state.copyWith(
        status: CVImportStatus.noText,
        errorMessage: 'No text found in PDF',
      );
      return state;
    }

    // Step 2: Notify UI that processing starts
    onProcessingStart?.call();

    // Step 3: Parse CV with backend
    state = state.copyWith(status: CVImportStatus.processing);

    try {
      final profile = await _repository.parseCV(cvText);
      state = state.copyWith(
        status: CVImportStatus.success,
        extractedProfile: profile,
      );
      return state;
    } catch (e) {
      state = state.copyWith(
        status: CVImportStatus.error,
        errorMessage: e.toString(),
      );
      return state;
    }
  }

  void reset() {
    state = const CVImportState();
  }
}

final cvImportProvider = NotifierProvider<CVImportNotifier, CVImportState>(
  CVImportNotifier.new,
);
