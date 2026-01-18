import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';

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
