import 'package:equatable/equatable.dart';

class CVTemplate extends Equatable {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl; 
  final bool isPremium;
  final List<String> tags; 

  const CVTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    this.isPremium = false,
    this.tags = const [],
  });

  factory CVTemplate.fromJson(Map<String, dynamic> json) {
    return CVTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      isPremium: json['isPremium'] as bool? ?? false,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  @override
  List<Object?> get props => [id, name, description, thumbnailUrl, isPremium, tags];
}
