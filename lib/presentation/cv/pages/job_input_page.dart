import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/job_input.dart';
import '../providers/cv_generation_provider.dart';
import '../providers/ocr_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../widgets/job/job_input_content.dart';
import '../../common/widgets/app_loading_screen.dart';

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

  // Draft Keys
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
    _debounceTimer = Timer(const Duration(milliseconds: 500), _saveDrafts);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Silakan lengkapi Master Profile Anda terlebih dahulu di menu Profile.'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      // Show Premium Loading Screen
      // We push it as a route so we can pop it later
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AppLoadingScreen(
            messages: [
              "Memvalidasi data...",
              "Menyiapkan profil...",
              "Melanjutkan ke form...",
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
        
        // Save Job Input to state
        ref.read(cvCreationProvider.notifier).setJobInput(jobInput);

        // Call AI to Tailor Profile
        final repository = ref.read(cvRepositoryProvider);
        final tailoredResult = await repository.tailorProfile(
          masterProfile: masterProfile, 
          jobInput: jobInput
        );
        
        if (mounted) {
           // Pop Loading Screen
           Navigator.of(context).pop();
           
           // Navigate to Next Page
           context.push('/create/user-data', extra: tailoredResult);
        }
      } catch (e) {
        if (mounted) {
          // Pop Loading Screen first
          Navigator.of(context).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menganalisis profil: $e'),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } 
      // Finally block removed as popping is handled in try/catch
    }
  }

  // OCR Methods
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
            const Text(
              'Scan Job Posting',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _scanJobPosting(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
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
    // Show modern loading screen
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) => const AppLoadingScreen(
          badge: "OCR SCANNING",
          messages: [
            "Membaca gambar...",
            "Mengekstrak teks...",
            "Menganalisis lowongan...",
            "Menyusun data...",
            "Finalisasi...",
          ],
        ),
      ),
    );

    // Use the OCR provider for business logic
    final ocrNotifier = ref.read(ocrProvider.notifier);
    final jobInput = await ocrNotifier.scanJobPosting(source);

    // Close loading screen
    if (mounted) {
      Navigator.of(context).pop();
    }

    // Handle result
    if (!mounted) return;

    if (jobInput != null) {
      // Auto-fill form fields
      _titleController.text = jobInput.jobTitle;
      _companyController.text = jobInput.company ?? '';
      _descController.text = jobInput.jobDescription ?? '';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Job posting extracted successfully!'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
        ),
      );
    } else {
      // Show error from provider state
      final errorMessage = ref.read(ocrProvider).error ?? 'Failed to extract job posting';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Posisi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_camera),
            tooltip: 'Scan Job Posting',
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
