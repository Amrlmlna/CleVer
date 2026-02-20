import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/cv_data.dart';
import '../../../domain/entities/job_input.dart';
import '../../../domain/entities/tailored_cv_result.dart'; 
import '../../cv/providers/cv_generation_provider.dart';
import '../providers/draft_provider.dart';
import '../widgets/drafts_content.dart';

class DraftsPage extends ConsumerStatefulWidget {
  const DraftsPage({super.key});

  @override
  ConsumerState<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends ConsumerState<DraftsPage> {
  String _searchQuery = '';
  String? _selectedFolder; 

  void _handleDraftSelection(CVData draft) {
    final notifier = ref.read(cvCreationProvider.notifier);
    
    notifier.setJobInput(JobInput(
      jobTitle: draft.jobTitle, 
      jobDescription: '',
    ));

    notifier.setUserProfile(draft.userProfile);

    notifier.setSummary(draft.summary);

    notifier.setStyle(draft.styleId);
    
    notifier.setCurrentDraftId(draft.id);

    final tailoredResult = TailoredCVResult(
      profile: draft.userProfile,
      summary: draft.summary,
    );
    context.push('/create/user-data', extra: tailoredResult);
  }

  void _handleDelete(String id, int currentFolderCount) {
    ref.read(draftsProvider.notifier).deleteDraft(id);
    if (currentFolderCount <= 1 && _selectedFolder != null) {
        setState(() {
          _selectedFolder = null;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final draftsAsync = ref.watch(draftsProvider);

    return Scaffold(
      body: draftsAsync.when(
        loading: () => DraftsContent(
          folders: const {},
          currentDrafts: const [],
          selectedFolderName: _selectedFolder,
          searchQuery: _searchQuery,
          isLoading: true,
          onSearchChanged: (val) {},
          onFolderSelected: (val) {},
          onDraftSelected: (val) {},
          onDraftDeleted: (val) {},
        ),
        error: (err, stack) => DraftsContent(
          folders: const {},
          currentDrafts: const [],
          selectedFolderName: _selectedFolder,
          searchQuery: _searchQuery,
          isLoading: false,
          errorMessage: err.toString(),
          onSearchChanged: (val) {},
          onFolderSelected: (val) {},
          onDraftSelected: (val) {},
          onDraftDeleted: (val) {},
        ),
        data: (drafts) {
            final filteredDrafts = _searchQuery.isEmpty 
                ? drafts 
                : drafts.where((d) => d.jobTitle.toLowerCase().contains(_searchQuery)).toList();
            final Map<String, List<CVData>> folders = {};
            for (var draft in filteredDrafts) {
              final key = draft.jobTitle.isNotEmpty ? draft.jobTitle : 'Tanpa Judul';
              if (!folders.containsKey(key)) {
                folders[key] = [];
              }
              folders[key]!.add(draft);
            }

            List<CVData> currentDrafts = [];
            if (_selectedFolder != null) {
               currentDrafts = folders[_selectedFolder] ?? [];
            }

            return DraftsContent(
              folders: folders,
              currentDrafts: currentDrafts,
              selectedFolderName: _selectedFolder,
              searchQuery: _searchQuery,
              isLoading: false,
              onSearchChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              onFolderSelected: (val) => setState(() => _selectedFolder = val),
              onDraftSelected: _handleDraftSelection,
              onDraftDeleted: (id) => _handleDelete(id, currentDrafts.length),
            );
        },
      ),
    );
  }
}
