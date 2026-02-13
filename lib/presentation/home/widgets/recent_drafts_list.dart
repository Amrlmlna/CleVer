import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../domain/entities/cv_data.dart';
import '../../../domain/entities/job_input.dart';
import '../../../domain/entities/tailored_cv_result.dart'; // Import
import '../../drafts/providers/draft_provider.dart';
import '../../cv/providers/cv_generation_provider.dart';

// ... imports

class RecentDraftsList extends ConsumerWidget {
  const RecentDraftsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(draftsProvider);

    return draftsAsync.when(
      data: (drafts) {
        if (drafts.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('Belum ada draft. Yuk bikin!')),
          );
        }

        // 1. Sort by Date Descending
        final sortedDrafts = List<CVData>.from(drafts)..sort((a,b) => b.createdAt.compareTo(a.createdAt));
        
        // 2. Take Top 3
        final recentDrafts = sortedDrafts.take(3).toList();

        return SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recentDrafts.length + 1, // +1 for "Lihat Semua"
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == recentDrafts.length) {
                return _buildSeeAllCard(context);
              }
              final draft = recentDrafts[index];
              return _buildDraftCard(context, ref, draft);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildDraftCard(BuildContext context, WidgetRef ref, CVData draft) {
    return InkWell(
      onTap: () {
        // Load Draft Data into Provider
        final notifier = ref.read(cvCreationProvider.notifier);
        
        notifier.setJobInput(JobInput(
          jobTitle: draft.jobTitle, 
          jobDescription: '',
        ));
        notifier.setUserProfile(draft.userProfile);
        notifier.setSummary(draft.summary);
        notifier.setStyle(draft.styleId);
        notifier.setLanguage(draft.language);

        // Navigate to Form for Editing
        final tailoredResult = TailoredCVResult(
          profile: draft.userProfile,
          summary: draft.summary,
        );
        context.push('/create/user-data', extra: tailoredResult);
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1), // Subtle shadow
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05), // Light grey icon bg
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.edit_document, size: 20, color: Colors.black), // Black icon
            ),
            const Spacer(),
            Text(
              draft.jobTitle.isNotEmpty ? draft.jobTitle : 'Tanpa Judul',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, fontFamily: 'Outfit'),
            ),
            const SizedBox(height: 6),
            Text(
              timeago.format(draft.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]), // Grey text
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeAllCard(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
      ),
      child: InkWell(
        onTap: () {
           context.go('/drafts');
        },
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Container(
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: Colors.white, // White circle
                 ),
                 child: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16), // Black icon
               ),
               const SizedBox(height: 12),
               const Text('Lihat\nSemua', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
