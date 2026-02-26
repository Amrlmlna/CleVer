import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import '../providers/job_provider.dart';
import 'job_card.dart';
import 'job_preview_bottom_sheet.dart';

class ApiJobsTab extends ConsumerWidget {
  const ApiJobsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(apiJobsProvider);

    return jobsAsync.when(
      data: (jobs) {
        if (jobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_off, size: 64, color: Colors.grey.shade800),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.jobListNoApiJobs,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.jobListNoApiJobsSub,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return JobCard(
              job: job,
              onTap: () {
                JobPreviewBottomSheet.show(context, job);
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
