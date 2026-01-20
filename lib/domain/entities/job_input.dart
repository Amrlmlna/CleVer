import 'package:equatable/equatable.dart';

class JobInput extends Equatable {
  final String jobTitle;
  final String? jobDescription;

  const JobInput({
    required this.jobTitle,
    this.jobDescription,
  });

  @override
  List<Object?> get props => [jobTitle, jobDescription];

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'company': 'Unknown Company', // Fallback as current JobInput doesn't have company field but backend expects it
      'description': jobDescription ?? '',
    };
  }
}
