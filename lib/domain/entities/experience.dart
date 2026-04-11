import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final String id;
  final String jobTitle;
  final String companyName;
  final String startDate;
  final String? endDate;
  final String description;
  final String? fingerprint;

  const Experience({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.startDate,
    this.endDate,
    required this.description,
    this.fingerprint,
  });

  Experience copyWith({
    String? id,
    String? jobTitle,
    String? companyName,
    String? startDate,
    String? endDate,
    String? description,
    String? fingerprint,
  }) {
    return Experience(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      fingerprint: fingerprint ?? this.fingerprint,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'fingerprint': fingerprint,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      jobTitle: json['jobTitle'] as String,
      companyName: json['companyName'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      description: json['description'] as String,
      fingerprint: json['fingerprint'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    jobTitle,
    companyName,
    startDate,
    endDate,
    fingerprint,
  ];
}
