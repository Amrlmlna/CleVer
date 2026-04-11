import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../presentation/cv/widgets/job/job_input_hero_card.dart';
import '../../../../presentation/cv/widgets/job/job_description_field.dart';
import '../providers/cv_generation_provider.dart';

class JobInputContent extends ConsumerStatefulWidget {
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
  ConsumerState<JobInputContent> createState() => _JobInputContentState();
}

class _JobInputContentState extends ConsumerState<JobInputContent> {
  String _hintText = '';
  int _currentStringIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  bool _isExpanded = false;
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
    final colorScheme = Theme.of(context).colorScheme;
    final tailoringOptions = ref.watch(cvCreationProvider).tailoringOptions;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              JobInputHeroCard(
                controller: widget.titleController,
                companyController: widget.companyController,
                hintText: _hintText,
                onSubmit: widget.onSubmit,
              ),

              const SizedBox(height: 32),

              JobDescriptionField(controller: widget.descController),

              const SizedBox(height: 24),

              // Advanced Options Toggle
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  expansionTileTheme: ExpansionTileThemeData(
                    iconColor: colorScheme.primary,
                    collapsedIconColor: colorScheme.primary.withValues(
                      alpha: 0.7,
                    ),
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.05),
                    ),
                  ),
                  child: ExpansionTile(
                    onExpansionChanged: (val) =>
                        setState(() => _isExpanded = val),
                    trailing: AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: _isExpanded ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                    title: Row(
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          size: 18,
                          color: colorScheme.primary.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.aiTailoringOptions,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface.withValues(alpha: 0.9),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              // Skill Limit Slider
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        l10n.maxSkills,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.8),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          '${tailoringOptions.maxSkills}',
                                          style: TextStyle(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: colorScheme.primary,
                                      inactiveTrackColor: colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      thumbColor: colorScheme.primary,
                                      overlayColor: colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      trackHeight: 4,
                                    ),
                                    child: Slider(
                                      value: tailoringOptions.maxSkills
                                          .toDouble(),
                                      min: 5,
                                      max: 20,
                                      divisions: 15,
                                      onChanged: (val) {
                                        ref
                                            .read(cvCreationProvider.notifier)
                                            .setTailoringOptions(
                                              tailoringOptions.copyWith(
                                                maxSkills: val.round(),
                                              ),
                                            );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(height: 1, thickness: 0.5),
                              ),

                              // Strict Mode (Honest Review)
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  l10n.honestAiFeedback,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  l10n.honestAiFeedbackDesc,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                value: tailoringOptions.strictMode,
                                activeColor: colorScheme.primary,
                                onChanged: (val) {
                                  ref
                                      .read(cvCreationProvider.notifier)
                                      .setTailoringOptions(
                                        tailoringOptions.copyWith(
                                          strictMode: val,
                                        ),
                                      );
                                },
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(height: 1, thickness: 0.5),
                              ),

                              // Concise Mode
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  l10n.conciseFormat,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  l10n.conciseFormatDesc,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                value: tailoringOptions.conciseMode,
                                activeColor: colorScheme.primary,
                                onChanged: (val) {
                                  ref
                                      .read(cvCreationProvider.notifier)
                                      .setTailoringOptions(
                                        tailoringOptions.copyWith(
                                          conciseMode: val,
                                        ),
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: widget.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          l10n.continueToReview,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
