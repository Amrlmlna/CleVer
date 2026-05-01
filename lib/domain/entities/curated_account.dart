import 'package:equatable/equatable.dart';

class CuratedAccount extends Equatable {
  final String id;
  final String name;
  final String handle;
  final String platform;
  final String url;
  final String description;
  final List<String> tags;
  final String? profileImageUrl;
  final String? location;
  final int? followersCount;

  const CuratedAccount({
    required this.id,
    required this.name,
    required this.handle,
    required this.platform,
    required this.url,
    required this.description,
    required this.tags,
    this.profileImageUrl,
    this.location,
    this.followersCount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    handle,
    platform,
    url,
    description,
    tags,
    profileImageUrl,
    location,
    followersCount,
  ];
}
