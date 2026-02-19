import 'package:equatable/equatable.dart';

class CVTemplate extends Equatable {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl; 
  final bool isPremium;
  final List<String> tags; 
  final int currentUsage;
  final int userCredits;

  const CVTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    this.isPremium = false,
    this.tags = const [],
    this.currentUsage = 0,
    this.userCredits = 0,
  });

  bool get isLocked => currentUsage >= 2 && userCredits <= 0;

  factory CVTemplate.fromJson(Map<String, dynamic> json) {
    return CVTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      isPremium: json['isPremium'] as bool? ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      currentUsage: json['currentUsage'] as int? ?? 0,
      userCredits: json['userCredits'] as int? ?? 0,
    );
  }

  CVTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnailUrl,
    bool? isPremium,
    List<String>? tags,
    int? currentUsage,
    int? userCredits,
  }) {
    return CVTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isPremium: isPremium ?? this.isPremium,
      tags: tags ?? this.tags,
      currentUsage: currentUsage ?? this.currentUsage,
      userCredits: userCredits ?? this.userCredits,
    );
  }

  @override
  List<Object?> get props => [id, name, description, thumbnailUrl, isPremium, tags, currentUsage, userCredits];
}
