import '../../domain/entities/job_posting.dart';

class JobPostingModel extends JobPosting {
  const JobPostingModel({
    required super.id,
    required super.title,
    required super.company,
    required super.description,
    required super.source,
    required super.sourceUrl,
    required super.postedAt,
    super.location,
    super.employmentType,
    super.requirements,
  });

  factory JobPostingModel.fromJson(Map<String, dynamic> json) {
    return JobPostingModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Unknown Title',
      company: json['company'] as String? ?? 'Unknown Company',
      description: json['description'] as String? ?? '',
      source: json['source'] as String? ?? 'api',
      sourceUrl: json['sourceUrl'] as String? ?? '',
      postedAt: json['postedAt'] != null
          ? DateTime.parse(json['postedAt'] as String).toLocal()
          : DateTime.now(),
      location: json['location'] as String?,
      employmentType: json['employmentType'] as String?,
      requirements: (json['requirements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'description': description,
      'source': source,
      'sourceUrl': sourceUrl,
      'postedAt': postedAt.toIso8601String(),
      'location': location,
      'employmentType': employmentType,
      'requirements': requirements,
    };
  }
}
