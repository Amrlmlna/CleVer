import 'package:equatable/equatable.dart';

/// Skill categories for professional CV organization.
enum SkillCategory {
  technical,
  soft,
  tools,
  languages;

  String get displayName {
    switch (this) {
      case SkillCategory.technical:
        return 'Technical';
      case SkillCategory.soft:
        return 'Soft Skills';
      case SkillCategory.tools:
        return 'Tools & Platforms';
      case SkillCategory.languages:
        return 'Languages';
    }
  }

  String get displayNameId {
    switch (this) {
      case SkillCategory.technical:
        return 'Teknis';
      case SkillCategory.soft:
        return 'Soft Skills';
      case SkillCategory.tools:
        return 'Alat & Platform';
      case SkillCategory.languages:
        return 'Bahasa';
    }
  }
}

class Skill extends Equatable {
  final String name;
  final SkillCategory category;

  const Skill({
    required this.name,
    this.category = SkillCategory.technical,
  });

  Skill copyWith({
    String? name,
    SkillCategory? category,
  }) {
    return Skill(
      name: name ?? this.name,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category.name,
    };
  }

  /// Parses a Skill from JSON map.
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String? ?? '',
      category: _parseCategory(json['category']),
    );
  }

  /// Backward compatibility: create a Skill from a plain string.
  /// Used during migration from List<String> to List<Skill>.
  factory Skill.fromString(String name) {
    return Skill(name: name, category: SkillCategory.technical);
  }

  /// Parse a SkillCategory from a string, defaulting to technical.
  static SkillCategory _parseCategory(dynamic value) {
    if (value is String) {
      return SkillCategory.values.firstWhere(
        (c) => c.name == value,
        orElse: () => SkillCategory.technical,
      );
    }
    return SkillCategory.technical;
  }

  @override
  List<Object?> get props => [name, category];

  @override
  String toString() => name;
}
