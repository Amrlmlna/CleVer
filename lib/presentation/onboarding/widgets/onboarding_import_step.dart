import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/user_profile.dart';
import '../../profile/utils/cv_import_handler.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class OnboardingImportStep extends ConsumerWidget {
  final VoidCallback onManualEntry;
  final Function(UserProfile) onImportSuccess;

  const OnboardingImportStep({
    super.key,
    required this.onManualEntry,
    required this.onImportSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.alreadyHaveCV,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.alreadyHaveCVSubtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          _OptionCard(
            title: AppLocalizations.of(context)!.importExistingCV,
            subtitle: AppLocalizations.of(context)!.importExistingCVDesc,
            onTap: () => CVImportHandler.showImportDialog(
              context: context,
              ref: ref,
              onImportSuccess: onImportSuccess,
            ),
          ),

          const SizedBox(height: 16),

          _OptionCard(
            title: AppLocalizations.of(context)!.startFromScratch,
            subtitle: AppLocalizations.of(context)!.startFromScratchDesc,
            onTap: onManualEntry,
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withValues(alpha: 0.04),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
