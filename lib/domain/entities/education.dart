import 'package:equatable/equatable.dart';
import '../../core/utils/format_utils.dart';
import 'subject.dart';

class Education extends Equatable {
  final String id;
  final String degree;
  final String schoolName;
  final String startDate;
  final String? endDate;
  final String? description;
  final String? gpa;
  final List<Subject> subjects;
  final String? fingerprint;

  const Education({
    required this.id,
    required this.degree,
    required this.schoolName,
    required this.startDate,
    this.endDate,
    this.description = '',
    this.gpa,
    this.subjects = const [],
    this.fingerprint,
  });

  Education copyWith({
    String? id,
    String? degree,
    String? schoolName,
    String? startDate,
    String? endDate,
    String? description,
    String? gpa,
    List<Subject>? subjects,
    String? fingerprint,
  }) {
    return Education(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      schoolName: schoolName ?? this.schoolName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      gpa: gpa ?? this.gpa,
      subjects: subjects ?? this.subjects,
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
      'gpa': gpa,
      'subjects': subjects.map((s) => s.toJson()).toList(),
      'fingerprint': fingerprint,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      degree: FormatUtils.ensureString(json['degree'], fallback: 'Degree'),
      schoolName: FormatUtils.ensureString(
        json['schoolName'] ?? json['school_name'],
        fallback: 'University',
      ),
      startDate:
          json['startDate'] as String? ?? json['start_date'] as String? ?? '2000-01',
      endDate: json['endDate'] as String? ?? json['end_date'] as String?,
      description: FormatUtils.ensureString(json['description']),
      gpa: json['gpa'] as String?,
      subjects:
          (json['subjects'] as List<dynamic>?)
              ?.map((s) => Subject.fromJson(s as Map<String, dynamic>))
              .toList() ??
          const [],
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
    gpa,
    subjects,
    fingerprint,
  ];
}
