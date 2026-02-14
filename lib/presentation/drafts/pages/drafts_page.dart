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
    // Load Draft Data into Provider
    final notifier = ref.read(cvCreationProvider.notifier);
    
    // 1. Job Input (Dummy desc since we don't save it in CVData yet)
    notifier.setJobInput(JobInput(
      jobTitle: draft.jobTitle, 
      jobDescription: '',
    ));

    // 2. Profile
    notifier.setUserProfile(draft.userProfile);

    // 3. Summary
    notifier.setSummary(draft.summary);

    // 4. Style & Language
    notifier.setStyle(draft.styleId);
    notifier.setLanguage(draft.language);

    // Navigate to Form for Editing
    final tailoredResult = TailoredCVResult(
      profile: draft.userProfile,
      summary: draft.summary,
    );
    context.push('/create/user-data', extra: tailoredResult);
  }

  void _handleDelete(String id, int currentFolderCount) {
    ref.read(draftsProvider.notifier).deleteDraft(id);
    // If folder becomes empty after delete, go back to folders
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
           // 1. Filter by Search (Global search on Job Title)
            final filteredDrafts = _searchQuery.isEmpty 
                ? drafts 
                : drafts.where((d) => d.jobTitle.toLowerCase().contains(_searchQuery)).toList();

            // 2. Group by Job Title
            final Map<String, List<CVData>> folders = {};
            for (var draft in filteredDrafts) {
              final key = draft.jobTitle.isNotEmpty ? draft.jobTitle : 'Tanpa Judul';
              if (!folders.containsKey(key)) {
                folders[key] = [];
              }
              folders[key]!.add(draft);
            }

            // 3. Get Current Drafts needed for the View
            List<CVData> currentDrafts = [];
            if (_selectedFolder != null) {
               currentDrafts = folders[_selectedFolder] ?? [];
               // Sort here if needed (Content sorts by passed list order? No, Content does sorting. Wait, Content does NOT do sorting on input list, it sorts inside listbuilder? Check Content. Content does sort.)
               // Actually, the previous implementation sorted INSIDE the builder. 
               // Best practice: Sort filtered data in Smart Component, pass Sorted Data to dumb component? 
               // Or let dumb component handle display sorting? 
               // The Content widget handles version calculation which implies it relies on sort order.
               // Let's rely on Content's internal sort for now or pre-sort here.
               // Content: `final sorted = List<CVData>.from(drafts)..sort(...)`
               // So we pass unsorted `currentDrafts` and Content sorts it. Correct.
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
