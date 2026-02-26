import 'package:equatable/equatable.dart';

class CuratedAccount extends Equatable {
  final String id;
  final String name;
  final String handle;
  final String platform; // 'instagram', 'tiktok', 'linkedin'
  final String url;
  final String description;
  final List<String> tags;
  final String? profileImageUrl;

  const CuratedAccount({
    required this.id,
    required this.name,
    required this.handle,
    required this.platform,
    required this.url,
    required this.description,
    required this.tags,
    this.profileImageUrl,
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
      ];
}
