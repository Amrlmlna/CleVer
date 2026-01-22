import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../domain/entities/cv_data.dart';
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

        return SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: drafts.length + 1, // +1 for "Lihat Semua"
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == drafts.length) {
                return _buildSeeAllCard(context);
              }
              final draft = drafts[index];
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
        ref.read(generatedCVProvider.notifier).loadCV(draft);
        context.push('/preview');
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Dark Card
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.edit_document, size: 20, color: Colors.white),
            ),
            const Spacer(),
            Text(
              draft.userProfile.fullName.isNotEmpty ? draft.userProfile.fullName : 'Tanpa Judul',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              timeago.format(draft.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
        color: Colors.transparent, // Transparent for "Ghost" look or Dark
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: () {
           context.go('/drafts');
        },
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Container(
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: Colors.white.withOpacity(0.05),
                 ),
                 child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
               ),
               const SizedBox(height: 8),
               const Text('Lihat Semua', style: TextStyle(fontSize: 12, color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }
}
