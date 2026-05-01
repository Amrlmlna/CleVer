import '../../domain/entities/curated_account.dart';

class CuratedAccountModel extends CuratedAccount {
  const CuratedAccountModel({
    required super.id,
    required super.name,
    required super.handle,
    required super.platform,
    required super.url,
    required super.description,
    required super.tags,
    super.profileImageUrl,
    super.location,
    super.followersCount,
  });

  factory CuratedAccountModel.fromJson(Map<String, dynamic> json) {
    return CuratedAccountModel(
      id: json['id'] as String,
      name: json['name'] as String,
      handle: json['handle'] as String,
      platform: json['platform'] as String,
      url: json['url'] as String,
      description: json['description'] as String,
      tags: (json['tags'] as List).map((e) => e as String).toList(),
      profileImageUrl: json['profileImageUrl'] as String?,
      location: json['location'] as String?,
      followersCount: json['followersCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      'platform': platform,
      'url': url,
      'description': description,
      'tags': tags,
      'profileImageUrl': profileImageUrl,
      'location': location,
      'followersCount': followersCount,
    };
  }
}
