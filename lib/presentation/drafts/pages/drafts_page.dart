import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../domain/entities/cv_data.dart';
import '../../../domain/entities/job_input.dart';
import '../../../domain/entities/tailored_cv_result.dart'; // Import
import '../../cv/providers/cv_generation_provider.dart';
import '../providers/draft_provider.dart';
import '../../ads/widgets/draft_banner_carousel.dart';

class DraftsPage extends ConsumerStatefulWidget {
  const DraftsPage({super.key});

  @override
  ConsumerState<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends ConsumerState<DraftsPage> {
  String _searchQuery = '';
  String? _selectedFolder; // If null, show folders. If set, show drafts in that folder.

  @override
  Widget build(BuildContext context) {
    final draftsAsync = ref.watch(draftsProvider);

    return PopScope(
      canPop: _selectedFolder == null,
      onPopInvokedWithResult: (didPop, result) {
         if (didPop) return;
         if (_selectedFolder != null) {
          setState(() {
            _selectedFolder = null;
          });
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedFolder == null) ...[
              Text(
                'Draft Saya',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari lowongan...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 24),
              // Ad Banner
              const DraftsBannerCarousel(),
            ] else ...[
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _selectedFolder = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedFolder!,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Expanded(
              child: draftsAsync.when(
                data: (drafts) {
                  if (drafts.isEmpty) {
                    return const Center(child: Text('Belum ada draft.'));
                  }

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

                  if (filteredDrafts.isEmpty) {
                     return const Center(child: Text('Ga ada lowongan yang cocok.'));
                  }

                  // 3. Render
                  if (_selectedFolder != null) {
                    // Show List of Specific Drafts
                    final folderDrafts = folders[_selectedFolder] ?? [];
                    return _buildDraftList(folderDrafts);
                  } else {
                    // Show Folders
                    return _buildFolderGrid(folders);
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildFolderGrid(Map<String, List<CVData>> folders) {
    // Sort keys alphabetically
    final keys = folders.keys.toList()..sort();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final title = keys[index];
        final count = folders[title]!.length;
        
        return InkWell(
          onTap: () {
            setState(() {
              _selectedFolder = title;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color, // Adaptive Card Color
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white.withValues(alpha: 0.1) 
                    : Colors.grey.shade200
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder, size: 48, color: Colors.amber[400]),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count draft',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraftList(List<CVData> drafts) {
    if (drafts.isEmpty) return const Center(child: Text('Folder kosong'));
    
    // Sort by Date Descending
    final sorted = List<CVData>.from(drafts)..sort((a,b) => b.createdAt.compareTo(a.createdAt));

    return ListView.separated(
      itemCount: sorted.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final draft = sorted[index];
        return Dismissible(
          key: Key(draft.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            ref.read(draftsProvider.notifier).deleteDraft(draft.id);
            // If empty, maybe go back? 
            if (sorted.length == 1) {
               setState(() {
                 _selectedFolder = null;
               });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color, // Adaptive Card Color
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white.withValues(alpha: 0.05) 
                    : Colors.grey.shade200
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.blue.withValues(alpha: 0.2) 
                      : Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.description, color: Colors.blue),
              ),
              title: Text(
                draft.userProfile.fullName.isNotEmpty ? draft.userProfile.fullName : 'Tanpa Judul',
                 style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Dibuat ${timeago.format(draft.createdAt)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
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
              },
            ),
          ),
        );
      },
    );
  }
}
