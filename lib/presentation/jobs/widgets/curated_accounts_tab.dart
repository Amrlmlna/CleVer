import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/router/app_routes.dart';

import '../providers/job_provider.dart';
import 'curated_account_card.dart';

class CuratedAccountsTab extends ConsumerStatefulWidget {
  const CuratedAccountsTab({super.key});

  @override
  ConsumerState<CuratedAccountsTab> createState() => _CuratedAccountsTabState();
}

class _CuratedAccountsTabState extends ConsumerState<CuratedAccountsTab> {
  String _searchQuery = '';
  String? _selectedTag;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accountsAsync = ref.watch(curatedAccountsProvider);

    return accountsAsync.when(
      data: (accounts) {
        final allTags = accounts.expand((acc) => acc.tags).toSet().toList()
          ..sort();

        final filteredAccounts = accounts.where((acc) {
          final matchesSearch =
              _searchQuery.isEmpty ||
              acc.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              acc.handle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              acc.tags.any(
                (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
              );

          final matchesTag =
              _selectedTag == null || acc.tags.contains(_selectedTag);

          return matchesSearch && matchesTag;
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.jobListSearchTagsHint,
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: allTags.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _FilterChip(
                      label: "All",
                      isSelected: _selectedTag == null,
                      onTap: () => setState(() => _selectedTag = null),
                    );
                  }
                  final tag = allTags[index - 1];
                  return _FilterChip(
                    label: tag,
                    isSelected: _selectedTag == tag,
                    onTap: () => setState(() => _selectedTag = tag),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredAccounts.isEmpty
                  ? _EmptyState(searchQuery: _searchQuery)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: filteredAccounts.length,
                      itemBuilder: (context, index) {
                        return CuratedAccountCard(
                          account: filteredAccounts[index],
                        );
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('$err', style: TextStyle(color: colorScheme.error)),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String searchQuery;

  const _EmptyState({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.jobListNoAccountsFound,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.jobListNoAccountsFoundDesc(searchQuery),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.feedback),
              icon: const Icon(Icons.feedback_outlined, size: 18),
              label: Text(l10n.jobListGiveFeedback),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.outlineVariant),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
