import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/remote_cv_datasource.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/repositories/cv_repository.dart';
import '../../../data/repositories/cv_repository_impl.dart';
import '../../../domain/entities/job_input.dart';

final remoteCVDataSourceProvider = Provider<RemoteCVDataSource>((ref) {
  return RemoteCVDataSource();
});

final cvRepositoryProvider = Provider<CVRepository>((ref) {
  final dataSource = ref.watch(remoteCVDataSourceProvider);
  return CVRepositoryImpl(remoteDataSource: dataSource);
});

class CVCreationState {
  final JobInput? jobInput;
  final UserProfile? userProfile;
  final String? summary;
  final String selectedStyle;
  final String? currentDraftId;


  const CVCreationState({
    this.jobInput,
    this.userProfile,
    this.summary,
    this.selectedStyle = 'ATS',
    this.currentDraftId,
  });

  CVCreationState copyWith({
    JobInput? jobInput,
    UserProfile? userProfile,
    String? summary,
    String? selectedStyle,
    String? currentDraftId,
  }) {
    return CVCreationState(
      jobInput: jobInput ?? this.jobInput,
      userProfile: userProfile ?? this.userProfile,
      summary: summary ?? this.summary,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      currentDraftId: currentDraftId ?? this.currentDraftId,
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


  void setCurrentDraftId(String id) {
    state = state.copyWith(currentDraftId: id);
  }
}

final cvCreationProvider = NotifierProvider<CVCreationNotifier, CVCreationState>(CVCreationNotifier.new);
