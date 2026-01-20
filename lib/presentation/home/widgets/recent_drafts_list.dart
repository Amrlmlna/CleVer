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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description_outlined, size: 20, color: Colors.black87),
            ),
            const Spacer(),
            Text(
              draft.userProfile.fullName.isNotEmpty ? draft.userProfile.fullName : 'Tanpa Judul',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              timeago.format(draft.createdAt),
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
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
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
           context.go('/drafts');
        },
        borderRadius: BorderRadius.circular(12),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(Icons.arrow_forward, color: Colors.grey),
               SizedBox(height: 4),
               Text('Lihat Semua', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
