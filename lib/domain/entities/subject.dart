import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  final String name;
  final String? description;
  final String? grade;

  const Subject({
    required this.name,
    this.description,
    this.grade,
  });

  Subject copyWith({
    String? name,
    String? description,
    String? grade,
  }) {
    return Subject(
      name: name ?? this.name,
      description: description ?? this.description,
      grade: grade ?? this.grade,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'grade': grade,
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      grade: json['grade'] as String?,
    );
  }

  @override
  List<Object?> get props => [name, description, grade];

  @override
  String toString() => name;
}
