import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/job_input.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../providers/cv_generation_provider.dart';
import '../providers/ocr_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../widgets/job/job_input_content.dart';
import '../../common/widgets/app_loading_screen.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class JobInputPage extends ConsumerStatefulWidget {
  const JobInputPage({super.key});

  @override
  ConsumerState<JobInputPage> createState() => _JobInputPageState();
}

class _JobInputPageState extends ConsumerState<JobInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController(); 
  final _descController = TextEditingController();

  static const String _kDraftTitleKey = 'draft_job_title';
  static const String _kDraftCompanyKey = 'draft_job_company'; 
  static const String _kDraftDescKey = 'draft_job_desc';

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _loadDrafts();
    _titleController.addListener(_onTextChanged);
    _companyController.addListener(_onTextChanged);
    _descController.addListener(_onTextChanged);
  }

  Future<void> _loadDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
       final savedTitle = prefs.getString(_kDraftTitleKey);
       final savedCompany = prefs.getString(_kDraftCompanyKey);
       final savedDesc = prefs.getString(_kDraftDescKey);
       
       if (savedTitle != null && _titleController.text.isEmpty) {
         _titleController.text = savedTitle;
       }
       if (savedCompany != null && _companyController.text.isEmpty) {
         _companyController.text = savedCompany;
       }
       if (savedDesc != null && _descController.text.isEmpty) {
         _descController.text = savedDesc;
       }
    }
  }

  void _onTextChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1000), _saveDrafts);
  }

  Future<void> _clearDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kDraftTitleKey);
    await prefs.remove(_kDraftCompanyKey);
    await prefs.remove(_kDraftDescKey);
  }

  Future<void> _saveDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDraftTitleKey, _titleController.text);
    await prefs.setString(_kDraftCompanyKey, _companyController.text);
    await prefs.setString(_kDraftDescKey, _descController.text);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final masterProfile = ref.read(masterProfileProvider);
      
      if (masterProfile == null) {
        CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.completeProfileFirst);
        return;
      }

      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => AppLoadingScreen(
            messages: [
              AppLocalizations.of(context)!.validatingData,
              AppLocalizations.of(context)!.preparingProfile,
              AppLocalizations.of(context)!.continuingToForm,
            ],
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );

      try {
        final jobInput = JobInput(
          jobTitle: _titleController.text,
          company: _companyController.text.isNotEmpty ? _companyController.text : null,
          jobDescription: _descController.text,
        );
        
        ref.read(cvCreationProvider.notifier).setJobInput(jobInput);

        final repository = ref.read(cvRepositoryProvider);
        final tailoredResult = await repository.tailorProfile(
          masterProfile: masterProfile, 
          jobInput: jobInput
        );
        
        if (mounted) {
           Navigator.of(context).pop();

           await _clearDrafts();
           
           context.push('/create/user-data', extra: tailoredResult);
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop();
          
          CustomSnackBar.showError(context, AppLocalizations.of(context)!.analyzeProfileError(e.toString()));
        }
      } 
    } else {
      CustomSnackBar.showError(context, AppLocalizations.of(context)!.fillJobTitle);
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.scanJobPosting,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.camera),
              onTap: () {
                Navigator.pop(context);
                _scanJobPosting(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.gallery),
              onTap: () {
                Navigator.pop(context);
                _scanJobPosting(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _scanJobPosting(ImageSource source) async {
    final ocrNotifier = ref.read(ocrProvider.notifier);
    bool loadingShown = false;
    
    final result = await ocrNotifier.scanJobPosting(
      source,
      onProcessingStart: () {
        if (!loadingShown && mounted) {
          loadingShown = true;
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: false,
              pageBuilder: (context, animation, secondaryAnimation) => AppLoadingScreen(
                badge: AppLocalizations.of(context)!.ocrScanning,
                messages: [
                  AppLocalizations.of(context)!.analyzingText,
                  AppLocalizations.of(context)!.identifyingVacancy,
                  AppLocalizations.of(context)!.organizingData,
                  AppLocalizations.of(context)!.finalizing,
                ],
              ),
            ),
          );
        }
      },
    );
    
    if (mounted && loadingShown) {
      Navigator.of(context).pop();
    }
    
    if (!mounted) return;

    switch (result.status) {
      case OCRStatus.success:
        _titleController.text = result.jobInput!.jobTitle;
        _companyController.text = result.jobInput!.company ?? '';
        _descController.text = result.jobInput!.jobDescription ?? '';
        CustomSnackBar.showSuccess(context, AppLocalizations.of(context)!.jobExtractionSuccess);

      case OCRStatus.cancelled:

      case OCRStatus.noText:
        CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.noTextFound);

      case OCRStatus.error:
        CustomSnackBar.showError(context, result.errorMessage ?? AppLocalizations.of(context)!.jobExtractionFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.targetPosition),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_camera),
            tooltip: AppLocalizations.of(context)!.scanJobPosting,
            onPressed: _showImageSourceDialog,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: JobInputContent(
        formKey: _formKey,
        titleController: _titleController,
        companyController: _companyController,
        descController: _descController,
        isLoading: _isLoading,
        onSubmit: _submit,
      ),
    );
  }
}
