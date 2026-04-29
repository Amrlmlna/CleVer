import 'package:flutter/material.dart';
import '../../../domain/entities/user_profile.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class ImportSuccessBottomSheet extends StatelessWidget {
  final UserProfile extractedProfile;
  final VoidCallback onContinue;

  const ImportSuccessBottomSheet({
    super.key,
    required this.extractedProfile,
    required this.onContinue,
  });

  static Future<void> show({
    required BuildContext context,
    required UserProfile extractedProfile,
    required VoidCallback onContinue,
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => ImportSuccessBottomSheet(
        extractedProfile: extractedProfile,
        onContinue: onContinue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasPersonalInfo =
        extractedProfile.fullName.isNotEmpty ||
        extractedProfile.email.isNotEmpty;
    final expCount = extractedProfile.experience.length;
    final eduCount = extractedProfile.education.length;
    final skillCount = extractedProfile.skills.length;
    final certCount = extractedProfile.certifications.length;

    final summaryItems = <_SummaryItem>[];

    if (hasPersonalInfo) {
      summaryItems.add(
        _SummaryItem(
          icon: Icons.person_outline,
          label: l10n.importSuccessPersonalInfo,
        ),
      );
    }
    if (expCount > 0) {
      summaryItems.add(
        _SummaryItem(
          icon: Icons.work_outline,
          label: l10n.importSuccessExperience(expCount),
        ),
      );
    }
    if (eduCount > 0) {
      summaryItems.add(
        _SummaryItem(
          icon: Icons.school_outlined,
          label: l10n.importSuccessEducation(eduCount),
        ),
      );
    }
    if (skillCount > 0) {
      summaryItems.add(
        _SummaryItem(
          icon: Icons.psychology_outlined,
          label: l10n.importSuccessSkills(skillCount),
        ),
      );
    }
    if (certCount > 0) {
      summaryItems.add(
        _SummaryItem(
          icon: Icons.verified_outlined,
          label: l10n.importSuccessCertifications(certCount),
        ),
      );
    }

    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 12, 32, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: theme.colorScheme.surface,
                  size: 48,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.importSuccessTitle.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -1.0,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                summaryItems.isEmpty
                    ? l10n.importSuccessNoNewData
                    : l10n.importSuccessSubtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              if (summaryItems.isNotEmpty) ...[
                Column(
                  children: [
                    for (int i = 0; i < summaryItems.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Icon(
                              summaryItems[i].icon,
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              summaryItems[i].label.toUpperCase(),
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onContinue();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onSurface,
                    foregroundColor: theme.colorScheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.importSuccessContinue.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: theme.colorScheme.surface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryItem {
  final IconData icon;
  final String label;

  const _SummaryItem({required this.icon, required this.label});
}
