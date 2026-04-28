import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../domain/entities/cv_data.dart';

class DraftsContent extends StatelessWidget {
  final Map<String, List<CVData>> folders;
  final List<CVData> currentDrafts;
  final String? selectedFolderName;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedFolderName == null) ...[
              TextField(
                controller: TextEditingController(text: searchQuery)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: searchQuery.length),
                  ),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(
                    context,
                  )!.searchJob.toUpperCase(),
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                onChanged: onSearchChanged,
              ),
              const SizedBox(height: 12),
            ],
            Expanded(child: _buildContent(context)),
          ],
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
        return Center(child: Text(AppLocalizations.of(context)!.noDrafts));
      }
      return _buildFolderGrid(context, folders);
    }
  }

  Widget _buildFolderGrid(
    BuildContext context,
    Map<String, List<CVData>> folders,
  ) {
    final keys = folders.keys.toList()..sort();

    if (keys.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noMatchingJobs));
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final title = keys[index];
        final count = folders[title]!.length;

        return InkWell(
          onTap: () => onFolderSelected(title),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_outward_rounded,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.2,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'DRAFTS',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraftList(BuildContext context, List<CVData> drafts) {
    if (drafts.isEmpty)
      return Center(child: Text(AppLocalizations.of(context)!.folderEmpty));

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: drafts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final draft = drafts[index];
        final version = drafts.length - index;
        final templateName = _getTemplateName(context, draft.styleId);

        return Dismissible(
          key: Key(draft.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
            ),
          ),
          onDismissed: (_) => onDraftDeleted(draft.id),
          child: InkWell(
            onTap: () => onDraftSelected(draft),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'V${version.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          templateName.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeago.format(draft.createdAt).toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_outward_rounded,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getTemplateName(BuildContext context, String id) {
    switch (id) {
      case 'ATS':
        return AppLocalizations.of(context)!.atsStandard;
      case 'Modern':
        return AppLocalizations.of(context)!.modernProfessional;
      case 'Creative':
        return AppLocalizations.of(context)!.creativeDesign;
      default:
        return id;
    }
  }
}
