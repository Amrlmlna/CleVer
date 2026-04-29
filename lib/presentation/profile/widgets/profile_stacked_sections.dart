import 'package:flutter/material.dart';
import '../models/profile_section_data.dart';
import 'section_card.dart';
import '../pages/section_edit_page.dart';

enum SectionType { personalInfo, experience, education, certifications, skills }

class ProfileStackedSections extends StatelessWidget {
  final List<ProfileSectionData> sections;
  final int skillsCount;
  final String skillsLabel;

  const ProfileStackedSections({
    super.key,
    required this.sections,
    required this.skillsCount,
    required this.skillsLabel,
  });

  void _openSection(
    BuildContext context,
    ProfileSectionData section,
    SectionType type,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SectionEditPage(
            title: section.title,
            icon: section.icon,
            bgColor: section.bgColor,
            textColor: section.textColor,
            iconBgColor: section.iconBgColor,
            iconColor: section.iconColor,
            sectionType: type,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  SectionType _getSectionType(int index) {
    return switch (index) {
      0 => SectionType.personalInfo,
      1 => SectionType.experience,
      2 => SectionType.education,
      3 => SectionType.certifications,
      4 => SectionType.skills,
      _ => SectionType.personalInfo,
    };
  }

  @override
  Widget build(BuildContext context) {
    const double overlapAmount = 48.0;
    final int total = sections.length;

    return Column(
      children: List.generate(total, (i) {
        final section = sections[i];
        final bool isLast = i == total - 1;
        final double bottomOverlap = isLast ? 160.0 : overlapAmount;
        final sectionType = _getSectionType(i);

        final card = ProfileSectionCard(
          title: section.title,
          icon: section.icon,
          backgroundColor: section.bgColor,
          textColor: section.textColor,
          iconBgColor: section.iconBgColor,
          iconColor: section.iconColor,
          bottomOverlap: bottomOverlap,
          onTap: () => _openSection(context, section, sectionType),
          bottomContent: isLast
              ? Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -30,
                      bottom: -20,
                      child: Icon(
                        Icons.code_rounded,
                        size: 160,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, right: 60.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$skillsCount",
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.0,
                                letterSpacing: -2.0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              skillsLabel.toLowerCase(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.8),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : null,
        );

        if (isLast) {
          return card;
        }

        return SizedBox(
          height: 80.0,
          child: OverflowBox(
            maxHeight: 80.0 + overlapAmount,
            alignment: Alignment.topCenter,
            child: card,
          ),
        );
      }),
    );
  }
}
