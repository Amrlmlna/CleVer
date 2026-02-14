import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/cv_data.dart';
import '../../../domain/repositories/draft_repository.dart';
import '../../../data/repositories/draft_repository_impl.dart';
import '../../cv/providers/cv_generation_provider.dart';
import 'package:uuid/uuid.dart';

final draftRepositoryProvider = Provider<DraftRepository>((ref) {
  return DraftRepositoryImpl();
});

final draftsProvider = AsyncNotifierProvider<DraftsNotifier, List<CVData>>(DraftsNotifier.new);

class DraftsNotifier extends AsyncNotifier<List<CVData>> {
  late final DraftRepository _repository;

  @override
  Future<List<CVData>> build() async {
    _repository = ref.read(draftRepositoryProvider);
    return _repository.getDrafts();
  }

  Future<void> saveDraft(CVData cv) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveDraft(cv);
      return _repository.getDrafts();
    });
  }

  Future<void> saveAllDrafts(List<CVData> drafts) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveAllDrafts(drafts);
      return _repository.getDrafts();
    });
  }

  Future<void> deleteDraft(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteDraft(id);
      return _repository.getDrafts();
    });
  }
  
  Future<void> saveFromState(CVCreationState creationState) async {
    if (creationState.jobInput == null || creationState.userProfile == null) {
      return;
    }

    final id = creationState.currentDraftId ?? const Uuid().v4();
    
    // Update state with ID if it was new
    if (creationState.currentDraftId == null) {
      ref.read(cvCreationProvider.notifier).setCurrentDraftId(id);
    }

    final cvData = CVData(
      id: id,
      userProfile: creationState.userProfile!,
      summary: creationState.summary ?? '',
      styleId: creationState.selectedStyle,
      createdAt: DateTime.now(),
      jobTitle: creationState.jobInput!.jobTitle,
      jobDescription: creationState.jobInput!.jobDescription ?? '',
    );

    await saveDraft(cvData);
  }

  Future<void> refresh() async {
     state = const AsyncValue.loading();
     state = await AsyncValue.guard(() => _repository.getDrafts());
  }
}
