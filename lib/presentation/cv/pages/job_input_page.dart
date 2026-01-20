import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/job_input.dart';
import '../providers/cv_generation_provider.dart';

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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final jobInput = JobInput(
        jobTitle: _titleController.text,
        jobDescription: _descController.text, // Could be empty, handled by backend
      );
      
      ref.read(cvCreationProvider.notifier).setJobInput(jobInput);
      context.push('/create/user-data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Target Pekerjaan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                // 1. Black Card (Hero Style)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                      const SizedBox(height: 16),
                      const Text(
                        'Lagi mau lamar kerja jadi apa nih?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AI bakal bantuin bikin CV yang pas banget buat posisi ini.',
                        style: TextStyle(color: Colors.white70, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      
                      // White Input Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _titleController,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: _hintText.isEmpty && _titleController.text.isEmpty 
                                      ? '' 
                                      : _hintText,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Wajib diisi ya';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: _submit,
                              child: const Icon(
                                Icons.arrow_circle_right,
                                color: Colors.black,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 2. Standard Description Field (Outside Card)
                const Text(
                  'Detail Lowongan (Opsional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Paste deskripsi pekerjaan, persyaratan, atau kualifikasi di sini...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50], 
                  ),
                ),

                const SizedBox(height: 24),
                
                // Bottom Button (Alternative Submit)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Lanjut: Isi Data Diri'),
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
