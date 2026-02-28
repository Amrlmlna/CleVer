import 'package:equatable/equatable.dart';

class BannerAd extends Equatable {
  final String id;
  final String imageUrl;
  final String? redirectUrl;
  final bool isActive;
  final int order;

  const BannerAd({
    required this.id,
    required this.imageUrl,
    this.redirectUrl,
    required this.isActive,
    required this.order,
  });

  factory BannerAd.fromJson(Map<String, dynamic> json) {
    return BannerAd(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      redirectUrl: json['redirectUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      order: json['order'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, imageUrl, redirectUrl, isActive, order];
}
