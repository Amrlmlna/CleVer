import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../data/datasources/ocr_datasource.dart';
import '../../../data/repositories/cv_import_repository.dart';
import '../../cv/providers/cv_generation_provider.dart';

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

final cvImportRepositoryProvider = Provider<CVImportRepository>((ref) {
  final dataSource = ref.watch(remoteCVDataSourceProvider);
  return CVImportRepository(remoteDataSource: dataSource);
});

class CVImportNotifier extends Notifier<CVImportState> {
  late OCRDataSource _ocrService;
  late CVImportRepository _repository;

  @override
  CVImportState build() {
    _ocrService = OCRDataSource();
    _repository = ref.watch(cvImportRepositoryProvider);
    return const CVImportState();
  }

  Future<CVImportState> importFromImage(
    ImageSource source, {
    Function()? onProcessingStart,
  }) async {
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

    onProcessingStart?.call();

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

  Future<CVImportState> importFromPDF({
    Function()? onProcessingStart,
  }) async {
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

    onProcessingStart?.call();

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
