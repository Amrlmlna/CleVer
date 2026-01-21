import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../common/widgets/ai_editable_text.dart';
import 'section_header.dart';

class PreviewExperience extends StatelessWidget {
  final List<Experience> experience;
  final Function(Experience, String) onUpdateDescription;
  final Future<String> Function(String) onRewrite;
  final String language;

  const PreviewExperience({
    super.key,
    required this.experience,
    required this.onUpdateDescription,
    required this.onRewrite,
    this.language = 'id',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: language == 'en' ? 'EXPERIENCE' : 'PENGALAMAN KERJA'),
        if (experience.isEmpty)
           Text(language == 'en' ? 'No experience listed.' : 'Belum ada pengalaman.'),
        ...experience.map((exp) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${exp.jobTitle} at ${exp.companyName}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '${exp.startDate} - ${exp.endDate ?? (language == 'en' ? "Present" : "Sekarang")}',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 4),
              AIEditableText(
                initialText: exp.description,
                style: Theme.of(context).textTheme.bodyMedium,
                onSave: (val) => onUpdateDescription(exp, val),
                onRewrite: onRewrite,
              ),
            ],
          ),
        )),
      ],
    );
  }
}
