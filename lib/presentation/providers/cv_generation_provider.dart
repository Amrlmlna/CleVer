import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/mock_ai_service.dart';
import '../../domain/entities/cv_data.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/cv_repository.dart';
import '../../data/repositories/cv_repository_impl.dart';
import '../../domain/entities/job_input.dart';

final mockAIServiceProvider = Provider<MockAIService>((ref) => MockAIService());

final cvRepositoryProvider = Provider<CVRepository>((ref) {
  final aiService = ref.watch(mockAIServiceProvider);
  return CVRepositoryImpl(mockAIService: aiService);
});

final generatedCVProvider = AsyncNotifierProvider<CVDisplayNotifier, CVData>(() {
  return CVDisplayNotifier();
});

final unsavedChangesProvider = StateProvider<bool>((ref) => false);

class CVDisplayNotifier extends AsyncNotifier<CVData> {
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

  Future<void> updateSummary(String newSummary) async {
    final currentState = state.value;
    if (currentState != null) {
      // Create new CVData with updated summary
      final updatedCV = CVData(
        id: currentState.id,
        userProfile: currentState.userProfile,
        generatedSummary: newSummary,
        tailoredSkills: currentState.tailoredSkills,
        styleId: currentState.styleId,
        createdAt: currentState.createdAt,
        jobTitle: currentState.jobTitle,
      );
      state = AsyncValue.data(updatedCV);
      ref.read(unsavedChangesProvider.notifier).state = true;
    }
  }

  Future<void> updateStyle(String newStyleId) async {
    final currentState = state.value;
    if (currentState != null) {
      final updatedCV = CVData(
        id: currentState.id,
        userProfile: currentState.userProfile,
        generatedSummary: currentState.generatedSummary,
        tailoredSkills: currentState.tailoredSkills,
        styleId: newStyleId,
        createdAt: currentState.createdAt,
        jobTitle: currentState.jobTitle,
      );
      state = AsyncValue.data(updatedCV);
      ref.read(unsavedChangesProvider.notifier).state = true;
    }
  }

  Future<void> updateExperience(Experience oldExp, String newDescription) async {
    final currentState = state.value;
    if (currentState != null) {
      final newExperienceList = currentState.userProfile.experience.map((e) {
        if (e == oldExp) {
          // Equatable makes this work if properties match
          // We need to create a copy of Experience with new description
          return Experience(
              jobTitle: e.jobTitle,
              companyName: e.companyName,
              startDate: e.startDate,
              endDate: e.endDate,
              description: newDescription);
        }
        return e;
      }).toList();

      final updatedProfile = currentState.userProfile.copyWith(experience: newExperienceList);
      
      final updatedCV = CVData(
        id: currentState.id,
        userProfile: updatedProfile,
        generatedSummary: currentState.generatedSummary,
        tailoredSkills: currentState.tailoredSkills,
        styleId: currentState.styleId,
        createdAt: currentState.createdAt,
        jobTitle: currentState.jobTitle,
      );
      state = AsyncValue.data(updatedCV);
      ref.read(unsavedChangesProvider.notifier).state = true;
    }
  }

  Future<void> addSkill(String newSkill) async {
    final currentState = state.value;
    if (currentState != null) {
      final updatedSkills = List<String>.from(currentState.tailoredSkills)..add(newSkill);
      
      final updatedCV = CVData(
        id: currentState.id,
        userProfile: currentState.userProfile,
        generatedSummary: currentState.generatedSummary,
        tailoredSkills: updatedSkills,
        styleId: currentState.styleId,
        createdAt: currentState.createdAt,
        jobTitle: currentState.jobTitle,
      );
      state = AsyncValue.data(updatedCV);
      ref.read(unsavedChangesProvider.notifier).state = true;
    }
  }

  void loadCV(CVData cvData) {
    state = AsyncValue.data(cvData);
    ref.read(unsavedChangesProvider.notifier).state = false; // Reset on load
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
    String? jobTitle,
  }) {
    return CVData(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      generatedSummary: generatedSummary ?? this.generatedSummary,
      tailoredSkills: tailoredSkills ?? this.tailoredSkills,
      styleId: styleId ?? this.styleId,
      createdAt: createdAt ?? this.createdAt,
      jobTitle: jobTitle ?? this.jobTitle,
    );
  }
}

class CVCreationState {
  final JobInput? jobInput;
  final UserProfile? userProfile;
  final String? selectedStyle;

  const CVCreationState({
    this.jobInput,
    this.userProfile,
    this.selectedStyle,
  });

  CVCreationState copyWith({
    JobInput? jobInput,
    UserProfile? userProfile,
    String? selectedStyle,
  }) {
    return CVCreationState(
      jobInput: jobInput ?? this.jobInput,
      userProfile: userProfile ?? this.userProfile,
      selectedStyle: selectedStyle ?? this.selectedStyle,
    );
  }
}

class CVCreationNotifier extends Notifier<CVCreationState> {
  @override
  CVCreationState build() {
    return const CVCreationState();
  }

  void setJobInput(JobInput input) {
    state = state.copyWith(jobInput: input);
  }

  void setUserProfile(UserProfile profile) {
    state = state.copyWith(userProfile: profile);
  }

  void setStyle(String style) {
    state = state.copyWith(selectedStyle: style);
  }
}

final cvCreationProvider = NotifierProvider<CVCreationNotifier, CVCreationState>(CVCreationNotifier.new);
