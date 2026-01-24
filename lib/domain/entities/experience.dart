import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final String jobTitle;
  final String companyName;
  final String startDate; // Simplified for now
  final String? endDate;
  final String description;

  const Experience({
    required this.jobTitle,
    required this.companyName,
    required this.startDate,
    this.endDate,
    required this.description,
  });

  Experience copyWith({
    String? jobTitle,
    String? companyName,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    return Experience(
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'companyName': companyName,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      jobTitle: json['jobTitle'] as String,
      companyName: json['companyName'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      description: json['description'] as String,
    );
  }

  @override
  List<Object?> get props => [jobTitle, companyName, startDate, endDate, description];
}
