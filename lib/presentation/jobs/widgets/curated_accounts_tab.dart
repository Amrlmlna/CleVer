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

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(curatedAccountsProvider);

    return accountsAsync.when(
      data: (accounts) {
        final filteredAccounts = _searchQuery.isEmpty 
            ? accounts 
            : accounts.where((acc) => 
                acc.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase())) ||
                acc.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                acc.handle.toLowerCase().contains(_searchQuery.toLowerCase())
              ).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.jobListSearchTagsHint,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.jobListScannerHint,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredAccounts.isEmpty 
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey.shade800),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.jobListNoAccountsFound,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.jobListNoAccountsFoundDesc(_searchQuery),
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => context.push(AppRoutes.feedback),
                              icon: const Icon(Icons.feedback_outlined, size: 18),
                              label: Text(AppLocalizations.of(context)!.jobListGiveFeedback),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: filteredAccounts.length,
                      itemBuilder: (context, index) {
                        return CuratedAccountCard(account: filteredAccounts[index]);
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
