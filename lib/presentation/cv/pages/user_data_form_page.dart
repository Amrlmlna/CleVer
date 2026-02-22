import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/cv_generation_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../widgets/form/user_data_form_content.dart';
import '../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import '../../../domain/entities/tailored_cv_result.dart';
import '../../auth/utils/auth_guard.dart';

class UserDataFormPage extends ConsumerStatefulWidget {
  final TailoredCVResult? tailoredResult;
  const UserDataFormPage({super.key, this.tailoredResult});

  @override
  ConsumerState<UserDataFormPage> createState() => _UserDataFormPageState();
}

class _UserDataFormPageState extends ConsumerState<UserDataFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  
  final _summaryController = TextEditingController();
  bool _isGeneratingSummary = false;
  
  List<Experience> _experience = [];
  List<Education> _education = [];
  List<String> _skills = [];
  List<Certification> _certifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final masterProfile = ref.read(masterProfileProvider);
      final creationState = ref.read(cvCreationProvider);
      
      final profileToUse = widget.tailoredResult?.profile ?? masterProfile;
      final isTailored = widget.tailoredResult != null;
      
      if (!mounted) return;

      if (profileToUse != null && _nameController.text.isEmpty) {
        setState(() {
          _nameController.text = profileToUse.fullName;
          _emailController.text = profileToUse.email;
          _phoneController.text = profileToUse.phoneNumber ?? '';
          _locationController.text = profileToUse.location ?? '';
          
          _experience = List<Experience>.from(profileToUse.experience);
          _education = List<Education>.from(profileToUse.education);
          _skills = List<String>.from(profileToUse.skills);
          _certifications = List<Certification>.from(profileToUse.certifications);
        });

        final initialSummary = widget.tailoredResult?.summary ?? creationState.summary;
        if (initialSummary != null) {
          _summaryController.text = initialSummary;
        }

        CustomSnackBar.showSuccess(
          context,
          isTailored 
            ? AppLocalizations.of(context)!.reviewedByAI
            : AppLocalizations.of(context)!.autoFillFromMaster,
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _generateSummary() async {
    final jobInput = ref.read(cvCreationProvider).jobInput;
    if (jobInput == null) {
      CustomSnackBar.showError(context, AppLocalizations.of(context)!.jobInputMissing);
      return;
    }

    setState(() {
      _isGeneratingSummary = true;
    });

    try {
      final currentProfile = UserProfile(
        fullName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        location: _locationController.text,
        experience: _experience,
        education: _education,
        skills: _skills,
        certifications: _certifications,
      );

      final repository = ref.read(cvRepositoryProvider);
      final cvData = await repository.generateCV(
        profile: currentProfile,
        jobInput: jobInput,
        styleId: 'ATS',
      );

      if (mounted) {
        setState(() {
          _summaryController.text = cvData.summary;
          _isGeneratingSummary = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGeneratingSummary = false);
        CustomSnackBar.showError(context, AppLocalizations.of(context)!.generateSummaryFailed(e.toString()));
      }
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        fullName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        location: _locationController.text,
        experience: _experience,
        education: _education,
        skills: _skills.isNotEmpty ? _skills : ['Leadership', 'Communication'], 
        certifications: _certifications,
      );

      ref.read(cvCreationProvider.notifier).setUserProfile(profile);
      ref.read(cvCreationProvider.notifier).setSummary(_summaryController.text);
      
      final hasChanges = await ref.read(masterProfileProvider.notifier).mergeProfile(profile);
      
      if (hasChanges && mounted) {
        CustomSnackBar.showSuccess(context, AppLocalizations.of(context)!.masterProfileUpdated);
      }

      if (mounted) {
        if (!AuthGuard.check(context, featureTitle: AppLocalizations.of(context)!.authWallSelectTemplate, featureDescription: AppLocalizations.of(context)!.authWallSelectTemplateDesc)) return;
        context.push('/create/style-selection');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reviewData),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.black, 
            foregroundColor: isDark ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Text(
            AppLocalizations.of(context)!.continueChooseTemplate,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: UserDataFormContent(
        formKey: _formKey,
        isDark: isDark,
        tailoredResult: widget.tailoredResult,
        nameController: _nameController,
        emailController: _emailController,
        phoneController: _phoneController,
        locationController: _locationController,
        summaryController: _summaryController,
        isGeneratingSummary: _isGeneratingSummary,
        experience: _experience,
        education: _education,
        skills: _skills,
        certifications: _certifications,
        onGenerateSummary: _generateSummary,
        onExperienceChanged: (val) => setState(() => _experience = val),
        onEducationChanged: (val) => setState(() => _education = val),
        onSkillsChanged: (val) => setState(() => _skills = val),
        onCertificationsChanged: (val) => setState(() => _certifications = val),
      ),
    );
  }
}
