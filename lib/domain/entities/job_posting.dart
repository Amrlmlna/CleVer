import 'package:equatable/equatable.dart';

class JobPosting extends Equatable {
  final String id;
  final String title;
  final String company;
  final String description;
  final String source; // 'api', 'manual'
  final String sourceUrl;
  final DateTime postedAt;
  final String? location;
  final String? employmentType; // full-time, part-time, etc
  final List<String>? requirements;

  const JobPosting({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.source,
    required this.sourceUrl,
    required this.postedAt,
    this.location,
    this. employmentType,
    this.requirements,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        company,
        description,
        source,
        sourceUrl,
        postedAt,
        location,
        employmentType,
        requirements,
      ];
}
