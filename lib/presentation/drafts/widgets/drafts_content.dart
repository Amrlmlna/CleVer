import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../domain/entities/cv_data.dart';
import '../../ads/widgets/draft_banner_carousel.dart';

class DraftsContent extends StatelessWidget {
  final Map<String, List<CVData>> folders;
  final List<CVData> currentDrafts; // Drafts to show when a folder is selected
  final String? selectedFolderName;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;
  
  // Callbacks
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onFolderSelected;
  final ValueChanged<CVData> onDraftSelected;
  final ValueChanged<String> onDraftDeleted;

  const DraftsContent({
    super.key,
    required this.folders,
    required this.currentDrafts,
    required this.selectedFolderName,
    required this.searchQuery,
    required this.isLoading,
    this.errorMessage,
    required this.onSearchChanged,
    required this.onFolderSelected,
    required this.onDraftSelected,
    required this.onDraftDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedFolderName == null,
      onPopInvokedWithResult: (didPop, result) {
         if (didPop) return;
         if (selectedFolderName != null) {
           onFolderSelected(null);
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedFolderName == null) ...[
                Text(
                  'Draft Saya',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                // Search Bar
                TextField(
                  controller: TextEditingController(text: searchQuery)
                    ..selection = TextSelection.fromPosition(TextPosition(offset: searchQuery.length)),
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
                  onChanged: onSearchChanged,
                ),
                const SizedBox(height: 24),
                // Ad Banner
                const DraftsBannerCarousel(),
              ] else ...[
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => onFolderSelected(null),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedFolderName!,
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
                child: _buildContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text('Error: $errorMessage'));
    }

    if (selectedFolderName != null) {
      return _buildDraftList(context, currentDrafts);
    } else {
      if (folders.isEmpty) {
         return const Center(child: Text('Belum ada draft.'));
      }
      return _buildFolderGrid(context, folders);
    }
  }

  Widget _buildFolderGrid(BuildContext context, Map<String, List<CVData>> folders) {
    // Sort keys alphabetically
    final keys = folders.keys.toList()..sort();

    if (keys.isEmpty) {
       return const Center(child: Text('Ga ada lowongan yang cocok.'));
    }

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
          onTap: () => onFolderSelected(title),
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

  Widget _buildDraftList(BuildContext context, List<CVData> drafts) {
    if (drafts.isEmpty) return const Center(child: Text('Folder kosong'));
    
    // Drafts are already sorted by the Smart Component

    return ListView.separated(
      itemCount: drafts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final draft = drafts[index];

        // Version Logic: Newest gets the highest number
        // e.g. 3 items. Index 0 (Newest) -> #3. Index 2 (Oldest) -> #1.
        final version = drafts.length - index;
        
        final title = draft.jobTitle.isNotEmpty 
            ? '${draft.jobTitle} #$version' 
            : 'Tanpa Judul #$version';
            
        final templateName = _getTemplateName(draft.styleId);
        final lang = draft.language == 'id' ? '🇮🇩 Indo' : '🇺🇸 English';

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
            onDraftDeleted(draft.id);
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
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: 4),
                   Text(
                    'Template: $templateName • $lang',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                   const SizedBox(height: 2),
                  Text(
                    'Dibuat ${timeago.format(draft.createdAt)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => onDraftSelected(draft),
            ),
          ),
        );
      },
    );
  }

  String _getTemplateName(String id) {
    switch (id) {
      case 'ATS': return 'ATS Standard';
      case 'Modern': return 'Modern Professional';
      case 'Creative': return 'Creative Design';
      default: return id;
    }
  }
}
