import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'package:clever/core/theme/app_colors.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final draftsAsync = ref.watch(draftsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // --- TOP ACCENT HEADER ---
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.accentPeach,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(48),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedFolder != null) ...[
                  IconButton(
                    onPressed: () => setState(() => _selectedFolder = null),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Text(
                  (_selectedFolder ?? AppLocalizations.of(context)!.myCVs)
                      .toUpperCase(),
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 1.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // --- TAB BAR SECTION ---
          if (_selectedFolder == null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 8),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: colorScheme.surface,
                  unselectedLabelColor: colorScheme.onSurface.withValues(
                    alpha: 0.4,
                  ),
                  labelStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                  unselectedLabelStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: [
                    Tab(
                      text: AppLocalizations.of(context)!.drafts.toUpperCase(),
                    ),
                    Tab(
                      text: AppLocalizations.of(
                        context,
                      )!.generated.toUpperCase(),
                    ),
                  ],
                ),
              ),
            ),
          ] else
            const SizedBox(height: 24),

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
