import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';
import 'section_header.dart';

class PreviewEducation extends StatelessWidget {
  final List<Education> education;
  final String language;

  const PreviewEducation({
    super.key,
    required this.education,
    this.language = 'id',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: language == 'en' ? 'EDUCATION' : 'PENDIDIKAN'),
        if (education.isEmpty)
           Text(language == 'en' ? 'No education listed.' : 'Belum ada pendidikan.'),
        ...education.map((edu) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(edu.schoolName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('${edu.degree} (${edu.startDate} - ${edu.endDate ?? (language == 'en' ? "Present" : "Sekarang")})'),
            ],
          ),
        )),
      ],
    );
  }
}
