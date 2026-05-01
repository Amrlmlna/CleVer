import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.alreadyHaveCV.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24,
              color: colorScheme.onSurface,
              letterSpacing: -1.0,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.alreadyHaveCVSubtitle,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(20),
            color: colorScheme.surfaceContainerHighest,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: colorScheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurface,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
