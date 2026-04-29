import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../core/services/tutorial_service.dart';
import '../../../core/theme/app_colors.dart';

import '../../../core/utils/custom_snackbar.dart';
import '../providers/job_input_controller.dart';
import '../widgets/job/job_input_content.dart';
import '../widgets/job/job_scan_bottom_sheet.dart';
import '../widgets/job/job_submit_button.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import '../../../domain/entities/job_input.dart';

class JobInputPage extends ConsumerStatefulWidget {
  final JobInput? initialJobInput;
  const JobInputPage({super.key, this.initialJobInput});

  @override
  ConsumerState<JobInputPage> createState() => _JobInputPageState();
}

class _JobInputPageState extends ConsumerState<JobInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _descController = TextEditingController();
  final GlobalKey _scanButtonKey = GlobalKey();

  late TutorialCoachMark _tutorialCoachMark;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    if (widget.initialJobInput != null) {
      _titleController.text = widget.initialJobInput!.jobTitle;
      _companyController.text = widget.initialJobInput!.company ?? '';
      _descController.text = widget.initialJobInput!.jobDescription ?? '';
    } else {
      _initDrafts();
    }
    _titleController.addListener(_onTextChanged);
    _companyController.addListener(_onTextChanged);
    _descController.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTutorial());
  }

  Future<void> _initDrafts() async {
    final drafts = await ref
        .read(jobInputControllerProvider.notifier)
        .loadDrafts();
    if (mounted) {
      if (_titleController.text.isEmpty)
        _titleController.text = drafts['title']!;
      if (_companyController.text.isEmpty)
        _companyController.text = drafts['company']!;
      if (_descController.text.isEmpty)
        _descController.text = drafts['description']!;
    }
  }

  void _onTextChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      ref
          .read(jobInputControllerProvider.notifier)
          .saveDrafts(
            title: _titleController.text,
            company: _companyController.text,
            description: _descController.text,
          );
    });
  }

  void _checkTutorial() async {
    final hasShown = await TutorialService().hasShownJobOcr();
    if (!hasShown && mounted) {
      _initTutorial();
      _tutorialCoachMark.show(context: context);
    }
  }

  void _initTutorial() {
    final l10n = AppLocalizations.of(context)!;
    _tutorialCoachMark = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "scan_button",
          keyTarget: _scanButtonKey,
          alignSkip: Alignment.bottomCenter,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.tutorialJobOcrTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.tutorialJobOcrDesc,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => controller.next(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(l10n.tutorialFinish),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      onClickTarget: (target) {
        if (target.identify == "scan_button") _showScanDialog();
      },
      colorShadow: Colors.black,
      textSkip: l10n.skipIntro,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () => TutorialService().markJobOcrAsShown(),
      onSkip: () {
        TutorialService().markJobOcrAsShown();
        return true;
      },
    );
  }

  void _showScanDialog() {
    JobScanBottomSheet.show(
      context,
      onImageSelected: (source) => ref
          .read(jobInputControllerProvider.notifier)
          .scanJobPosting(
            context: context,
            source: source,
            onFound: (input) {
              _titleController.text = input.jobTitle;
              _companyController.text = input.company ?? '';
              _descController.text = input.jobDescription ?? '';
            },
          ),
      onPdfSelected: () => ref
          .read(jobInputControllerProvider.notifier)
          .scanJobPostingFromPDF(
            context: context,
            onFound: (input) {
              _titleController.text = input.jobTitle;
              _companyController.text = input.company ?? '';
              _descController.text = input.jobDescription ?? '';
            },
          ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(jobInputControllerProvider.notifier)
          .submit(
            context: context,
            title: _titleController.text,
            company: _companyController.text,
            description: _descController.text,
          );
    } else {
      CustomSnackBar.showError(
        context,
        AppLocalizations.of(context)!.fillJobTitle,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // ─── INDUSTRIAL PEACH HEADER ───────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.accentPeach,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(48)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Top row: Back + Scan ─────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                    // Scan icon — tutorial key lives HERE
                    IconButton(
                      key: _scanButtonKey,
                      onPressed: _showScanDialog,
                      icon: const Icon(
                        Icons.document_scanner_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ─── Title ────────────────────────────────────────────
                Text(
                  l10n.whatJobApply,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 0.3,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.aiHelpCreateCV,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // ─── SCROLLABLE FORM CONTENT ───────────────────────────────
          Expanded(
            child: JobInputContent(
              formKey: _formKey,
              titleController: _titleController,
              companyController: _companyController,
              descController: _descController,
            ),
          ),

          // ─── FIXED BOTTOM SUBMIT BUTTON ────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: JobSubmitButton(
                isLoading: ref.watch(jobInputControllerProvider).isLoading,
                onTap: _handleSubmit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
