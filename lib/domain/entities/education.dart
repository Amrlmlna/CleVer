import 'package:equatable/equatable.dart';
import '../../core/utils/format_utils.dart';

class Education extends Equatable {
  final String id;
  final String degree;
  final String schoolName;
  final String startDate;
  final String? endDate;
  final String description;
  final String? fingerprint;

  const Education({
    required this.id,
    required this.degree,
    required this.schoolName,
    required this.startDate,
    this.endDate,
    this.description = '',
    this.fingerprint,
  });

  Education copyWith({
    String? id,
    String? degree,
    String? schoolName,
    String? startDate,
    String? endDate,
    String? description,
    String? fingerprint,
  }) {
    return Education(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      schoolName: schoolName ?? this.schoolName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
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
      'description': description,
      'fingerprint': fingerprint,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      degree: FormatUtils.ensureString(json['degree'], fallback: 'Degree'),
      schoolName: FormatUtils.ensureString(json['schoolName'], fallback: 'University'),
      startDate: json['startDate'] as String? ?? '2000-01',
      endDate: json['endDate'] as String?,
      description: FormatUtils.ensureString(json['description']),
      fingerprint: json['fingerprint'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    degree,
    schoolName,
    startDate,
    endDate,
    description,
    fingerprint,
  ];
}
