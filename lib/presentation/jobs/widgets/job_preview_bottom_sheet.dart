import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/entities/job_posting.dart';
import '../../../../domain/entities/job_input.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/router/app_routes.dart';

class JobPreviewBottomSheet extends StatelessWidget {
  final JobPosting job;

  const JobPreviewBottomSheet({super.key, required this.job});

  static void show(BuildContext context, JobPosting job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JobPreviewBottomSheet(job: job),
    );
  }

  Future<void> _launchSourceUrl(BuildContext context) async {
    final url = Uri.parse(job.sourceUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          AppLocalizations.of(context)!.jobCouldNotOpen,
        );
      }
    }
  }

  void _createCV(BuildContext context) {
    Navigator.pop(context); // Close the bottom sheet
    // We pass the job data to the CV creator page.
    final existingJobInput = JobInput(
      jobTitle: job.title,
      company: job.company,
      jobDescription: job.description,
    );
    // Ideally we pass this via extra in stateful routing or a provider override.
    // For now, depending on your app_router, we can just push. We'll send it via extra if the route supports it,
    // or just rely on the user to copy/paste if extra casting isn't set up yet. 
    // Wait, the router doesn't take extra for createJobInput currently. Let's send them there and notify.
    context.push(AppRoutes.createJobInput, extra: existingJobInput);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    job.company.isNotEmpty ? job.company[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
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
                      job.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.company,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.jobDescription,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    job.description,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  if (job.requirements != null && job.requirements!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.jobRequirements,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...job.requirements!.map(
                      (req) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: Colors.white, fontSize: 16)),
                            Expanded(
                              child: Text(
                                req,
                                style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _launchSourceUrl(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.jobListViewOriginal),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _createCV(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.jobListCreateCvForJob),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
