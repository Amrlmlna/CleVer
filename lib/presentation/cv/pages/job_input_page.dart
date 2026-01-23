import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/job_input.dart';
import '../providers/cv_generation_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../widgets/job/job_input_hero_card.dart';
import '../widgets/job/job_description_field.dart';

class JobInputPage extends ConsumerStatefulWidget {
  const JobInputPage({super.key});

  @override
  ConsumerState<JobInputPage> createState() => _JobInputPageState();
}

class _JobInputPageState extends ConsumerState<JobInputPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  // Animation State
  String _hintText = '';
  int _currentStringIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _typingTimer;

  final List<String> _jobExamples = [
    'Barista',
    'Software Engineer',
    'Social Media Specialist',
    'Project Manager',
    'Graphic Designer',
    'Data Analyst',
  ];

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;

      setState(() {
        final currentString = _jobExamples[_currentStringIndex];

        if (_isDeleting) {
          if (_charIndex > 0) {
            _charIndex--;
          } else {
            _isDeleting = false;
            _currentStringIndex = (_currentStringIndex + 1) % _jobExamples.length;
          }
        } else {
          if (_charIndex < currentString.length) {
            _charIndex++;
          } else {
            // Wait a bit before deleting
            _isDeleting = true;
            // Delay the deletion slightly by skipping one tick logic or resetting timer? 
            // Simple hack: let it pause by expecting a longer char index? 
            // For simplicity in this `periodic`, we'll just let it bounce immediately 
            // or add a pause mechanic. Let's add a pause mechanic.
          }
        }
        
        // Pause handling at end of string
        if (_charIndex == currentString.length && !_isDeleting) {
           _typingTimer?.cancel();
           Future.delayed(const Duration(seconds: 2), () {
             if (mounted) {
               _isDeleting = true;
               _startTypingAnimation(); // Restart loop
             }
           });
        } else {
          _hintText = currentString.substring(0, _charIndex);
        }
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final masterProfile = ref.read(masterProfileProvider);
      
      if (masterProfile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan lengkapi Master Profile Anda terlebih dahulu di menu Profile.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final jobInput = JobInput(
          jobTitle: _titleController.text,
          jobDescription: _descController.text,
        );
        
        // Save Job Input to state
        ref.read(cvCreationProvider.notifier).setJobInput(jobInput);

        // Call AI to Tailor Profile
        final repository = ref.read(cvRepositoryProvider);
        final tailoredProfile = await repository.tailorProfile(
          masterProfile: masterProfile, 
          jobInput: jobInput
        );
        
        if (mounted) {
           context.push('/create/user-data', extra: tailoredProfile);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menganalisis profil: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine theme brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Posisi'),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Clean look
        foregroundColor: isDark ? Colors.white : Colors.black, // Explicit Contrast
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. White Hero Card
                JobInputHeroCard(
                  controller: _titleController,
                  hintText: _hintText,
                  onSubmit: _submit,
                ),

                const SizedBox(height: 32),

                // 2. Description Field (Adaptive/Dark)
                JobDescriptionField(controller: _descController),

                const SizedBox(height: 48),
                
                // Bottom Button (White CTA)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White Btn
                      foregroundColor: Colors.black, // Black Text
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : const Text('Lanjut: Review Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
