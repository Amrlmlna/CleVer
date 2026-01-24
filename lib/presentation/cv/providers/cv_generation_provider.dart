import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/remote_ai_service.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/repositories/cv_repository.dart';
import '../../../data/repositories/cv_repository_impl.dart';
import '../../../domain/entities/job_input.dart';

import '../../../core/config/app_config.dart';
import '../../../data/datasources/mock_ai_service.dart';

final remoteAIServiceProvider = Provider<RemoteAIService>((ref) {
  if (AppConfig.useMockAI) {
    return MockAIService();
  }
  return RemoteAIService();
});

final cvRepositoryProvider = Provider<CVRepository>((ref) {
  final aiService = ref.watch(remoteAIServiceProvider);
  return CVRepositoryImpl(aiService: aiService);
});

class CVCreationState {
  final JobInput? jobInput;
  final UserProfile? userProfile;
  final String? summary; // Added summary field
  final String? selectedStyle;
  final String language; // 'id' or 'en'


  const CVCreationState({
    this.jobInput,
    this.userProfile,
    this.summary,
    this.selectedStyle,
    this.language = 'id', // Default to Indonesian
  });

  CVCreationState copyWith({
    JobInput? jobInput,
    UserProfile? userProfile,
    String? summary,
    String? selectedStyle,
    String? language,
  }) {
    return CVCreationState(
      jobInput: jobInput ?? this.jobInput,
      userProfile: userProfile ?? this.userProfile,
      summary: summary ?? this.summary,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      language: language ?? this.language,
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

  void setSummary(String summary) {
    state = state.copyWith(summary: summary);
  }

  void setStyle(String style) {
    state = state.copyWith(selectedStyle: style);
  }

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
  }
}

final cvCreationProvider = NotifierProvider<CVCreationNotifier, CVCreationState>(CVCreationNotifier.new);
