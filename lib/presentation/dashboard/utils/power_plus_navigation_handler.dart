import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../profile/pages/section_edit_page.dart';
import '../../profile/widgets/profile_stacked_sections.dart';
import '../../profile/models/profile_section_data.dart';
import '../../../core/theme/app_colors.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class PowerPlusNavigationHandler {
  static void openSection(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    SectionType type,
  ) {
    final l10n = AppLocalizations.of(context)!;

    navigationShell.goBranch(3);

    ProfileSectionData? sectionData;
    switch (type) {
      case SectionType.experience:
        sectionData = ProfileSectionData(
          title: l10n.experience,
          icon: Icons.work_outline,
          bgColor: AppColors.vibrantYellow,
          textColor: Colors.black,
          iconBgColor: Colors.black,
          iconColor: Colors.white,
          child: const SizedBox.shrink(),
        );
        break;
      case SectionType.education:
        sectionData = ProfileSectionData(
          title: l10n.educationHistory,
          icon: Icons.school_outlined,
          bgColor: AppColors.vibrantBlack,
          textColor: Colors.white,
          iconBgColor: Colors.white,
          iconColor: Colors.black,
          child: const SizedBox.shrink(),
        );
        break;
      case SectionType.certifications:
        sectionData = ProfileSectionData(
          title: l10n.certifications,
          icon: Icons.card_membership,
          bgColor: AppColors.vibrantGreen,
          textColor: Colors.black,
          iconBgColor: Colors.white,
          iconColor: Colors.black,
          child: const SizedBox.shrink(),
        );
        break;
      case SectionType.skills:
        sectionData = ProfileSectionData(
          title: l10n.skills,
          icon: Icons.code,
          bgColor: AppColors.vibrantBlue,
          textColor: Colors.white,
          iconBgColor: Colors.white,
          iconColor: Colors.black,
          child: const SizedBox.shrink(),
        );
        break;
      default:
        return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SectionEditPage(
            title: sectionData!.title,
            icon: sectionData.icon,
            bgColor: sectionData.bgColor,
            textColor: sectionData.textColor,
            iconBgColor: sectionData.iconBgColor,
            iconColor: sectionData.iconColor,
            sectionType: type,
            autoOpenAddSheet: true,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
