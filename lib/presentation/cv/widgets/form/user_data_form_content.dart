import 'package:flutter/material.dart';
import '../../../../domain/entities/education.dart';
import '../../../../domain/entities/experience.dart';
import '../../../profile/widgets/education_list_form.dart';
import '../../../profile/widgets/experience_list_form.dart';
import '../../../profile/widgets/skills_input_form.dart';
import '../../../profile/widgets/personal_info_form.dart';
import 'tailored_data_header.dart';
import 'review_section_card.dart';
import 'summary_section.dart';
import 'master_profile_checkbox.dart';

import '../../../../domain/entities/tailored_cv_result.dart';

class UserDataFormContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isDark;
  final TailoredCVResult? tailoredResult;
  
  // Controllers
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final TextEditingController summaryController;

  // State
  final bool isGeneratingSummary;
  final List<Experience> experience;
  final List<Education> education;
  final List<String> skills;
  final bool updateMasterProfile;

  // Callbacks
  final VoidCallback onGenerateSummary;
  final ValueChanged<List<Experience>> onExperienceChanged;
  final ValueChanged<List<Education>> onEducationChanged;
  final ValueChanged<List<String>> onSkillsChanged;
  final ValueChanged<bool?> onUpdateMasterProfileChanged;

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
    required this.isGeneratingSummary,
    required this.experience,
    required this.education,
    required this.skills,
    required this.updateMasterProfile,
    required this.onGenerateSummary,
    required this.onExperienceChanged,
    required this.onEducationChanged,
    required this.onSkillsChanged,
    required this.onUpdateMasterProfileChanged,
  });

  @override
  State<UserDataFormContent> createState() => _UserDataFormContentState();
}

class _UserDataFormContentState extends State<UserDataFormContent> {
  // Accordion State
  bool _isPersonalExpanded = false;
  bool _isSummaryExpanded = true; 
  bool _isExperienceExpanded = false;
  bool _isEducationExpanded = false;
  bool _isSkillsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Message
            if (widget.tailoredResult != null)
              TailoredDataHeader(isDark: widget.isDark),

            // 1. Personal Info Section
            ReviewSectionCard(
              title: 'Informasi Personal',
              icon: Icons.person_outline,
              isExpanded: _isPersonalExpanded,
              onExpansionChanged: (val) => setState(() => _isPersonalExpanded = val),
               child: PersonalInfoForm(
                  nameController: widget.nameController,
                  emailController: widget.emailController,
                  phoneController: widget.phoneController,
                  locationController: widget.locationController,
                ),
            ),
            const SizedBox(height: 16),

            // 2. Professional Summary
            ReviewSectionCard(
              title: 'Professional Summary',
              icon: Icons.description_outlined,
              isExpanded: _isSummaryExpanded,
              onExpansionChanged: (val) => setState(() => _isSummaryExpanded = val),
              child: SummarySection(
                controller: widget.summaryController,
                isGenerating: widget.isGeneratingSummary,
                onGenerate: widget.onGenerateSummary,
                isDark: widget.isDark,
              ),
            ),
            const SizedBox(height: 16),

            // 3. Experience Section
            ReviewSectionCard(
              title: 'Pengalaman Kerja',
              icon: Icons.work_outline,
              isExpanded: _isExperienceExpanded,
              onExpansionChanged: (val) => setState(() => _isExperienceExpanded = val),
              child: ExperienceListForm(
                  experiences: widget.experience,
                  onChanged: widget.onExperienceChanged,
                ),
            ),
            const SizedBox(height: 16),

            // 4. Education Section
            ReviewSectionCard(
              title: 'Riwayat Pendidikan',
              icon: Icons.school_outlined,
              isExpanded: _isEducationExpanded,
              onExpansionChanged: (val) => setState(() => _isEducationExpanded = val),
                 child: EducationListForm(
                  education: widget.education,
                  onChanged: widget.onEducationChanged,
                ),
            ),
            const SizedBox(height: 16),

            // 5. Skills Section
            ReviewSectionCard(
              title: 'Keahlian (Skills)',
              icon: Icons.lightbulb_outline,
              isExpanded: _isSkillsExpanded,
              onExpansionChanged: (val) => setState(() => _isSkillsExpanded = val),
              child: Column(
                  children: [
                    SkillsInputForm(
                      skills: widget.skills,
                      onChanged: widget.onSkillsChanged,
                    ),
                    const SizedBox(height: 24),
                    MasterProfileCheckbox(
                      value: widget.updateMasterProfile,
                      onChanged: widget.onUpdateMasterProfileChanged,
                      isDark: widget.isDark,
                    ),
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
