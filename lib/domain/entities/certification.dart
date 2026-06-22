import 'package:equatable/equatable.dart';
import '../../core/utils/format_utils.dart';

/// Parses a date string that may be in YYYY-MM (month-precision) or
/// full ISO 8601 format. Month-precision strings default to the 1st.
DateTime _parseCertDate(String? raw) {
  final dateStr = raw?.trim();
  if (dateStr == null || dateStr.isEmpty) return DateTime.now();
  // Match YYYY-MM (month precision) — prepend "-01" before parsing
  if (RegExp(r'^\d{4}-\d{2}$').hasMatch(dateStr)) {
    final parsed = DateTime.tryParse('$dateStr-01');
    if (parsed != null) return parsed;
  }
  return DateTime.tryParse(dateStr) ?? DateTime.now();
}

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
      name: FormatUtils.ensureString(json['name'], fallback: 'Certification'),
      issuer: FormatUtils.ensureString(
        json['issuer'],
        fallback: 'Organization',
      ),
      date: _parseCertDate(json['date'] as String?),
      description: FormatUtils.ensureString(json['description']),
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
