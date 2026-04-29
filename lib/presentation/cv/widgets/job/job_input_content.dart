import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'job_input_hero_card.dart';
import 'job_description_field.dart';
import 'job_tailoring_options_section.dart';

class JobInputContent extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController companyController;
  final TextEditingController descController;

  const JobInputContent({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.companyController,
    required this.descController,
  });

  @override
  ConsumerState<JobInputContent> createState() => _JobInputContentState();
}

class _JobInputContentState extends ConsumerState<JobInputContent> {
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
            _currentStringIndex =
                (_currentStringIndex + 1) % _jobExamples.length;
          }
        } else {
          if (_charIndex < currentString.length) {
            _charIndex++;
          } else {
            _isDeleting = true;
          }
        }

        if (_charIndex == currentString.length && !_isDeleting) {
          _typingTimer?.cancel();
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _isDeleting = true;
              _startTypingAnimation();
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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            JobInputHeroCard(
              controller: widget.titleController,
              companyController: widget.companyController,
              hintText: _hintText,
            ),
            const SizedBox(height: 20),
            JobDescriptionField(controller: widget.descController),
            const SizedBox(height: 20),
            const JobTailoringOptionsSection(),
          ],
        ),
      ),
    );
  }
}
