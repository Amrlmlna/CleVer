import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/mock_ai_service.dart';
import '../../domain/entities/cv_data.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/cv_repository.dart';
import '../../data/repositories/cv_repository_impl.dart';
import 'cv_creation_provider.dart';

final mockAIServiceProvider = Provider<MockAIService>((ref) => MockAIService());

final cvRepositoryProvider = Provider<CVRepository>((ref) {
  final aiService = ref.watch(mockAIServiceProvider);
  return CVRepositoryImpl(mockAIService: aiService);
});

final generatedCVProvider = AsyncNotifierProvider.autoDispose<CVDisplayNotifier, CVData>(CVDisplayNotifier.new);

class CVDisplayNotifier extends AutoDisposeAsyncNotifier<CVData> {
  @override
  Future<CVData> build() async {
    // Accessing ref via property
    final creationState = ref.watch(cvCreationProvider);
    final repository = ref.watch(cvRepositoryProvider);

    if (creationState.jobInput == null || 
        creationState.userProfile == null || 
        creationState.selectedStyle == null) {
      // Return a partial or throw? Throwing will trigger error state in UI
      // However, usually we redirect before this if data is missing.
      // For safety, we can return dummy or throw.
      throw Exception('Incomplete Data'); 
    }

    return repository.generateCV(
      profile: creationState.userProfile!,
      jobInput: creationState.jobInput!,
      styleId: creationState.selectedStyle!,
    );
  }

  void updateSummary(String newSummary) {
    final currentValue = state.value;
    if (currentValue != null) {
      state = AsyncData(currentValue.copyWith(generatedSummary: newSummary));
    }
  }
}

extension CVDataCopyWith on CVData {
  CVData copyWith({
    String? id,
    UserProfile? userProfile,
    String? generatedSummary,
    List<String>? tailoredSkills,
    String? styleId,
    DateTime? createdAt,
  }) {
    return CVData(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      generatedSummary: generatedSummary ?? this.generatedSummary,
      tailoredSkills: tailoredSkills ?? this.tailoredSkills,
      styleId: styleId ?? this.styleId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
