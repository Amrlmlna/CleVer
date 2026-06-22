import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../providers/completed_cv_provider.dart';
import 'completed_cv_card.dart';

class CompletedCVsGrid extends ConsumerStatefulWidget {
  const CompletedCVsGrid({super.key});

  @override
  ConsumerState<CompletedCVsGrid> createState() => _CompletedCVsGridState();
}

class _CompletedCVsGridState extends ConsumerState<CompletedCVsGrid> {
  String _searchQuery = '';
  String? _selectedTemplateFilter;

  String _getTemplateDisplayName(BuildContext context, String id) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'ATS':
        return l10n.atsStandard;
      case 'Creative':
        return l10n.creativeDesign;
      default:
        return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedAsync = ref.watch(completedCVProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return completedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Text(
          'ERROR: ${err.toString().toUpperCase()}',
          style: TextStyle(color: colorScheme.error),
        ),
      ),
      data: (cvs) {
        if (cvs.isEmpty) {
          return _buildEmptyState(colorScheme, l10n);
        }

        // --- Derive unique template IDs for filter chips ---
        final uniqueTemplateIds =
            cvs.map((cv) => cv.templateId).toSet().toList()..sort();

        // --- Apply filters ---
        final filteredCvs = cvs.where((cv) {
          final matchesSearch =
              _searchQuery.isEmpty ||
              cv.jobTitle.toLowerCase().contains(_searchQuery);
          final matchesFilter =
              _selectedTemplateFilter == null ||
              cv.templateId == _selectedTemplateFilter;
          return matchesSearch && matchesFilter;
        }).toList();

        return Column(
          children: [
            // --- SEARCH BAR ---
            TextField(
              decoration: InputDecoration(
                hintText: l10n.searchGeneratedCvs.toUpperCase(),
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  fontSize: 12,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colorScheme.onSurface,
                ),
                filled: true,
                fillColor: colorScheme.onSurface.withValues(alpha: 0.05),
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
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              onChanged: (val) =>
                  setState(() => _searchQuery = val.toLowerCase()),
            ),
            const SizedBox(height: 12),

            // --- TEMPLATE FILTER CHIPS ---
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip(
                    context,
                    label: l10n.allFilter.toUpperCase(),
                    isSelected: _selectedTemplateFilter == null,
                    onTap: () => setState(() => _selectedTemplateFilter = null),
                  ),
                  ...uniqueTemplateIds.map(
                    (id) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _buildFilterChip(
                        context,
                        label: _getTemplateDisplayName(
                          context,
                          id,
                        ).toUpperCase(),
                        isSelected: _selectedTemplateFilter == id,
                        onTap: () =>
                            setState(() => _selectedTemplateFilter = id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- GRID ---
            Expanded(
              child: filteredCvs.isEmpty
                  ? _buildNoResultsState(colorScheme, textTheme, l10n)
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                      itemCount: filteredCvs.length,
                      itemBuilder: (context, index) {
                        return CompletedCVCard(cv: filteredCvs[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.onSurface
              : colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
            color: isSelected ? colorScheme.surface : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            size: 48,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noCompletedCVs.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.generateCVFirst.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noMatchingPdfs.toUpperCase(),
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
