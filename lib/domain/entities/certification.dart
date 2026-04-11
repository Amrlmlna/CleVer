import 'package:equatable/equatable.dart';

class Certification extends Equatable {
  final String id;
  final String name;
  final String issuer;
  final DateTime date;
  final String? description;
  final String? fingerprint;

  const Certification({
    required this.id,
    required this.name,
    required this.issuer,
    required this.date,
    this.description,
    this.fingerprint,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      description: json['description'] as String?,
      fingerprint: json['fingerprint'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issuer': issuer,
      'date': date.toIso8601String(),
      'description': description,
      'fingerprint': fingerprint,
    };
  }

  Certification copyWith({
    String? id,
    String? name,
    String? issuer,
    DateTime? date,
    String? description,
    String? fingerprint,
  }) {
    return Certification(
      id: id ?? this.id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      date: date ?? this.date,
      description: description ?? this.description,
      fingerprint: fingerprint ?? this.fingerprint,
    );
  }

  @override
  List<Object?> get props => [id, name, issuer, date, description, fingerprint];
}
