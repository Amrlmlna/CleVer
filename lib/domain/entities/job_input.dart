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
}
