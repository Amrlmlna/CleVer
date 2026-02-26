import 'package:equatable/equatable.dart';

class RequirementCheck extends Equatable {
  final String field;
  final bool isMet;
  final String message;

  const RequirementCheck({
    required this.field,
    required this.isMet,
    required this.message,
  });

  factory RequirementCheck.fromJson(Map<String, dynamic> json) {
    return RequirementCheck(
      field: json['field'] as String? ?? 'Requirement',
      isMet: json['isMet'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'field': field, 'isMet': isMet, 'message': message};
  }

  @override
  List<Object?> get props => [field, isMet, message];
}

class TailorAnalysis extends Equatable {
  final String naturalResponse;
  final List<RequirementCheck> requirementChecks;

  const TailorAnalysis({
    required this.naturalResponse,
    this.requirementChecks = const [],
  });

  factory TailorAnalysis.fromJson(Map<String, dynamic> json) {
    return TailorAnalysis(
      naturalResponse: json['naturalResponse'] as String? ?? '',
      requirementChecks:
          (json['requirementChecks'] as List<dynamic>?)
              ?.map((e) => RequirementCheck.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'naturalResponse': naturalResponse,
      'requirementChecks': requirementChecks.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [naturalResponse, requirementChecks];
}
