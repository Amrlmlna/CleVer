import 'package:equatable/equatable.dart';

class CVTemplate extends Equatable {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final List<String> previewUrls;
  final bool isPremium;
  final List<String> tags;
  final int currentUsage;
  final bool isSubscribed;
  final DateTime? subscriptionExpiry;
  final String? subscriptionType;
  final bool supportsPhoto;

  const CVTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    this.previewUrls = const [],
    this.isPremium = false,
    this.tags = const [],
    this.currentUsage = 0,
    this.isSubscribed = false,
    this.subscriptionExpiry,
    this.subscriptionType,
    this.supportsPhoto = false,
  });

  bool get hasFreeGeneration => currentUsage < 2;
  bool get isLocked => !hasFreeGeneration && !isSubscribed;

  factory CVTemplate.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      if (date is String) return DateTime.tryParse(date);
      return null;
    }

    return CVTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      previewUrls: List<String>.from(json['previewUrls'] ?? []),
      isPremium: json['isPremium'] as bool? ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      currentUsage: json['currentUsage'] as int? ?? 0,
      isSubscribed: json['isSubscribed'] as bool? ?? false,
      subscriptionExpiry: parseDate(json['subscriptionExpiry']),
      subscriptionType: json['subscriptionType'] as String?,
      supportsPhoto: json['supportsPhoto'] as bool? ?? false,
    );
  }

  CVTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnailUrl,
    List<String>? previewUrls,
    bool? isPremium,
    List<String>? tags,
    int? currentUsage,
    bool? isSubscribed,
    DateTime? subscriptionExpiry,
    String? subscriptionType,
    bool? supportsPhoto,
  }) {
    return CVTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      previewUrls: previewUrls ?? this.previewUrls,
      isPremium: isPremium ?? this.isPremium,
      tags: tags ?? this.tags,
      currentUsage: currentUsage ?? this.currentUsage,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      supportsPhoto: supportsPhoto ?? this.supportsPhoto,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    thumbnailUrl,
    previewUrls,
    isPremium,
    tags,
    currentUsage,
    isSubscribed,
    subscriptionExpiry,
    subscriptionType,
    supportsPhoto,
  ];
}
