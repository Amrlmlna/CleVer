import 'package:equatable/equatable.dart';

class JobInput extends Equatable {
  final String jobTitle;
  final String? company;
  final String? jobDescription;

  const JobInput({
    required this.jobTitle,
    this.company,
    this.jobDescription,
  });

  @override
  List<Object?> get props => [jobTitle, company, jobDescription];

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'company': company ?? 'Unknown Company',
      'description': jobDescription ?? '',
    };
  }
}
