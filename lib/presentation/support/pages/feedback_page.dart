import 'package:flutter/material.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/success_bottom_sheet.dart';
import '../../../core/services/analytics_service.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/config/api_config.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String _feedbackType = 'Saran Fitur';
  final _msgController = TextEditingController();
  final _contactController = TextEditingController();
  bool _isLoading = false;

  late List<String> _types;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _types = [
      AppLocalizations.of(context)!.bugReport,
      AppLocalizations.of(context)!.featureRequest,
      AppLocalizations.of(context)!.question,
      AppLocalizations.of(context)!.other,
    ];
    if (!_types.contains(_feedbackType)) {
      _feedbackType = _types.first;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/feedback'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': _feedbackType,
          'message': _msgController.text,
          'contact': _contactController.text,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('Feedback API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Feedback Network Error: $e');
    }
    AnalyticsService().trackEvent(
      'feedback_sent',
      properties: {'type': _feedbackType},
    );

    if (mounted) {
      setState(() => _isLoading = false);
      SuccessBottomSheet.show(
        context: context,
        title: AppLocalizations.of(context)!.thankYou,
        message: AppLocalizations.of(context)!.feedbackThanksMessage,
        onConfirm: () => Navigator.pop(context),
      );
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sendFeedback),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.howCanWeHelp,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.feedbackSubtitle,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.category,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.outlineVariant),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _feedbackType,
                          isExpanded: true,
                          dropdownColor: colorScheme.surfaceContainerHigh,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          items: _types
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _feedbackType = val!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    CustomTextFormField(
                      controller: _msgController,
                      labelText: AppLocalizations.of(context)!.messageDetail,
                      maxLines: 5,
                      validator: (v) => v!.isEmpty
                          ? AppLocalizations.of(context)!.writeSomething
                          : null,
                    ),
                    const SizedBox(height: 24),

                    CustomTextFormField(
                      controller: _contactController,
                      labelText: AppLocalizations.of(context)!.contactOptional,
                      hintText: AppLocalizations.of(context)!.contactHint,
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: colorScheme.onPrimary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.sendFeedback,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
