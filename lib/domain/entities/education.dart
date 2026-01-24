import 'package:equatable/equatable.dart';

class Education extends Equatable {
  final String degree;
  final String schoolName;
  final String startDate;
  final String? endDate;

  const Education({
    required this.degree,
    required this.schoolName,
    required this.startDate,
    this.endDate,
  });

  Education copyWith({
    String? degree,
    String? schoolName,
    String? startDate,
    String? endDate,
  }) {
    return Education(
      degree: degree ?? this.degree,
      schoolName: schoolName ?? this.schoolName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'schoolName': schoolName,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'] as String,
      schoolName: json['schoolName'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
    );
  }

  @override
  List<Object?> get props => [degree, schoolName, startDate, endDate];
}
