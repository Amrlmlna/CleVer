import 'package:equatable/equatable.dart';

class Certification extends Equatable {
  final String id; // UUID or meaningful ID
  final String name;
  final String issuer;
  final DateTime date;
  final String? description;

  const Certification({
    required this.id,
    required this.name,
    required this.issuer,
    required this.date,
    this.description,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issuer': issuer,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  Certification copyWith({
    String? id,
    String? name,
    String? issuer,
    DateTime? date,
    String? description,
  }) {
    return Certification(
      id: id ?? this.id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, issuer, date, description];
}
