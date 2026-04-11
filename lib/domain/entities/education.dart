import 'package:equatable/equatable.dart';

class Education extends Equatable {
  final String id;
  final String degree;
  final String schoolName;
  final String startDate;
  final String? endDate;
  final String? fingerprint;

  const Education({
    required this.id,
    required this.degree,
    required this.schoolName,
    required this.startDate,
    this.endDate,
    this.fingerprint,
  });

  Education copyWith({
    String? id,
    String? degree,
    String? schoolName,
    String? startDate,
    String? endDate,
    String? fingerprint,
  }) {
    return Education(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      schoolName: schoolName ?? this.schoolName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      fingerprint: fingerprint ?? this.fingerprint,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'degree': degree,
      'schoolName': schoolName,
      'startDate': startDate,
      'endDate': endDate,
      'fingerprint': fingerprint,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      degree: json['degree'] as String,
      schoolName: json['schoolName'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      fingerprint: json['fingerprint'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, degree, schoolName, startDate, endDate, fingerprint];
}
