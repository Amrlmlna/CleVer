import 'package:flutter/material.dart';
import '../../../common/widgets/ai_editable_text.dart';
import 'section_header.dart';

class PreviewSummary extends StatelessWidget {
  final String summary;
  final Function(String) onSave;
  final Future<String> Function(String) onRewrite;
  final String language;

  const PreviewSummary({
    super.key,
    required this.summary,
    required this.onSave,
    required this.onRewrite,
    this.language = 'id',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: language == 'en' ? 'PROFESSIONAL SUMMARY' : 'RINGKASAN PROFESIONAL'),
        AIEditableText(
          initialText: summary,
          style: Theme.of(context).textTheme.bodyLarge,
          onSave: onSave,
          onRewrite: onRewrite,
        ),
      ],
    );
  }
}
