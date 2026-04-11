import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../domain/entities/cv_data.dart';
import '../../../domain/entities/job_input.dart';
import '../../../domain/entities/tailored_cv_result.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../providers/draft_provider.dart';
import '../widgets/drafts_content.dart';
import '../widgets/completed_cvs_grid.dart';

class DraftsPage extends ConsumerStatefulWidget {
  const DraftsPage({super.key});

  @override
  ConsumerState<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends ConsumerState<DraftsPage>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String? _selectedFolder;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleDraftSelection(CVData draft) {
    final notifier = ref.read(cvCreationProvider.notifier);

    notifier.setJobInput(
      JobInput(jobTitle: draft.jobTitle, jobDescription: ''),
    );

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                AppLocalizations.of(context)!.myCVs,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Theme.of(context).colorScheme.onSurface,
                  unselectedLabelColor: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  labelPadding: EdgeInsets.zero,
                  padding: const EdgeInsets.all(3),
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.drafts),
                    Tab(text: AppLocalizations.of(context)!.generated),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDraftsTab(draftsAsync),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CompletedCVsGrid(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftsTab(AsyncValue<List<CVData>> draftsAsync) {
    return draftsAsync.when(
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
            : drafts
                  .where((d) => d.jobTitle.toLowerCase().contains(_searchQuery))
                  .toList();
        final Map<String, List<CVData>> folders = {};
        for (var draft in filteredDrafts) {
          final key = draft.jobTitle.isNotEmpty
              ? draft.jobTitle
              : 'Tanpa Judul';
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
          onSearchChanged: (val) =>
              setState(() => _searchQuery = val.toLowerCase()),
          onFolderSelected: (val) => setState(() => _selectedFolder = val),
          onDraftSelected: _handleDraftSelection,
          onDraftDeleted: (id) => _handleDelete(id, currentDrafts.length),
        );
      },
    );
  }
}
