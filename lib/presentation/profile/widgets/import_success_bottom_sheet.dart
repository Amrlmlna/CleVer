import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: const Color(0xFF1E1E1E),
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

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                l10n.importSuccessTitle,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                summaryItems.isEmpty
                    ? l10n.importSuccessNoNewData
                    : l10n.importSuccessSubtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              if (summaryItems.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white12),
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < summaryItems.length; i++) ...[
                        _SummaryRow(item: summaryItems[i]),
                        if (i < summaryItems.length - 1)
                          Divider(
                            color: Colors.white.withValues(alpha: 0.06),
                            height: 20,
                          ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.importSuccessContinue,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
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

class _SummaryRow extends StatelessWidget {
  final _SummaryItem item;

  const _SummaryRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Text(
          item.label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
