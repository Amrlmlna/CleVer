import 'package:flutter/material.dart';
import '../../../../domain/entities/education.dart';
import '../../../../domain/entities/experience.dart';
import '../../../../domain/entities/certification.dart';
import '../../../profile/widgets/education_list_form.dart';
import '../../../profile/widgets/experience_list_form.dart';
import '../../../profile/widgets/certification_list_form.dart';
import '../../../profile/widgets/skills_input_form.dart';
import '../../../profile/widgets/personal_info_form.dart';
import 'review_section_card.dart';
import 'summary_section.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import '../../../../domain/entities/tailored_cv_result.dart';
import 'requirement_checklist.dart';

class UserDataFormContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isDark;
  final TailoredCVResult? tailoredResult;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final TextEditingController summaryController;
  final TextEditingController birthDateController;
  final TextEditingController genderController;

  final List<Experience> experience;
  final List<Education> education;
  final List<String> skills;
  final List<Certification> certifications;

  final ValueChanged<List<Experience>> onExperienceChanged;
  final ValueChanged<List<Education>> onEducationChanged;
  final ValueChanged<List<String>> onSkillsChanged;
  final ValueChanged<List<Certification>> onCertificationsChanged;

  const UserDataFormContent({
    super.key,
    required this.formKey,
    required this.isDark,
    required this.tailoredResult,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
    required this.summaryController,
    required this.birthDateController,
    required this.genderController,
    required this.experience,
    required this.education,
    required this.skills,
    required this.certifications,
    required this.onExperienceChanged,
    required this.onEducationChanged,
    required this.onSkillsChanged,
    required this.onCertificationsChanged,
  });

  @override
  State<UserDataFormContent> createState() => _UserDataFormContentState();
}

class _UserDataFormContentState extends State<UserDataFormContent> {
  bool _isPersonalExpanded = false;
  bool _isSummaryExpanded = true;
  bool _isExperienceExpanded = false;
  bool _isEducationExpanded = false;
  bool _isSkillsExpanded = false;
  bool _isCertificationsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (widget.tailoredResult?.analysis != null)
              RequirementChecklist(
                analysis: widget.tailoredResult!.analysis!,
                isDark: widget.isDark,
              ),

            ReviewSectionCard(
              title: AppLocalizations.of(context)!.personalInfo,
              icon: Icons.person_outline,
              isExpanded: _isPersonalExpanded,
              onExpansionChanged: (val) =>
                  setState(() => _isPersonalExpanded = val),
              child: PersonalInfoForm(
                nameController: widget.nameController,
                emailController: widget.emailController,
                phoneController: widget.phoneController,
                locationController: widget.locationController,
                birthDateController: widget.birthDateController,
                genderController: widget.genderController,
              ),
            ),
            const SizedBox(height: 16),

            ReviewSectionCard(
              title: AppLocalizations.of(context)!.professionalSummary,
              icon: Icons.description_outlined,
              isExpanded: _isSummaryExpanded,
              onExpansionChanged: (val) =>
                  setState(() => _isSummaryExpanded = val),
              child: SummarySection(
                controller: widget.summaryController,
                isDark: widget.isDark,
              ),
            ),
            const SizedBox(height: 16),

            ReviewSectionCard(
              title: AppLocalizations.of(context)!.workExperience,
              icon: Icons.work_outline,
              isExpanded: _isExperienceExpanded,
              onExpansionChanged: (val) =>
                  setState(() => _isExperienceExpanded = val),
              child: ExperienceListForm(
                experiences: widget.experience,
                onChanged: widget.onExperienceChanged,
              ),
            ),
            const SizedBox(height: 16),

            ReviewSectionCard(
              title: AppLocalizations.of(context)!.educationHistory,
              icon: Icons.school_outlined,
              isExpanded: _isEducationExpanded,
              onExpansionChanged: (val) =>
                  setState(() => _isEducationExpanded = val),
              child: EducationListForm(
                education: widget.education,
                onChanged: widget.onEducationChanged,
              ),
            ),
            const SizedBox(height: 16),

            ReviewSectionCard(
              title: AppLocalizations.of(context)!.certificationsLicenses,
              icon: Icons.card_membership,
              isExpanded: _isCertificationsExpanded,
              onExpansionChanged: (val) =>
                  setState(() => _isCertificationsExpanded = val),
              child: CertificationListForm(
                certifications: widget.certifications,
                onChanged: widget.onCertificationsChanged,
              ),
            ),
            const SizedBox(height: 16),

            ReviewSectionCard(
              title: AppLocalizations.of(context)!.skills,
              icon: Icons.lightbulb_outline,
              isExpanded: _isSkillsExpanded,
              onExpansionChanged: (val) =>
                  setState(() => _isSkillsExpanded = val),
              child: Column(
                children: [
                  SkillsInputForm(
                    skills: widget.skills,
                    onChanged: widget.onSkillsChanged,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
