import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../presentation/cv/widgets/job/job_input_hero_card.dart';
import '../../../../presentation/cv/widgets/job/job_description_field.dart';

class JobInputContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController companyController;
  final TextEditingController descController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const JobInputContent({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.companyController,
    required this.descController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<JobInputContent> createState() => _JobInputContentState();
}

class _JobInputContentState extends State<JobInputContent> {
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

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. White Hero Card
              JobInputHeroCard(
                controller: widget.titleController,
                companyController: widget.companyController,
                hintText: _hintText,
                onSubmit: widget.onSubmit,
              ),

              const SizedBox(height: 32),

              // 2. Description Field (Adaptive/Dark)
              JobDescriptionField(controller: widget.descController),

              const SizedBox(height: 48),
              
              // Bottom Button (White CTA)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White Btn
                    foregroundColor: Colors.black, // Black Text
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: widget.isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Text('Lanjut: Review Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
