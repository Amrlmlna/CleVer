import '../../domain/entities/banner_ad.dart';

class DefaultBanners {
  static const List<BannerAd> list = [
    BannerAd(
      id: 'default_tailor',
      imageUrl: 'assets/images/default_banner_tailor.png',
      isActive: true,
      order: 1,
    ),
    BannerAd(
      id: 'default_templates',
      imageUrl: 'assets/images/default_banner_templates.png',
      isActive: true,
      order: 2,
    ),
  ];
}
