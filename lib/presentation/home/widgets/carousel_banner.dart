import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/banner_provider.dart';
import '../../../core/constants/default_banners.dart';
import '../../../domain/entities/banner_ad.dart';

class CarouselBanner extends ConsumerStatefulWidget {
  const CarouselBanner({super.key});

  @override
  ConsumerState<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends ConsumerState<CarouselBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bannerAsync = ref.watch(bannerProvider);

    return bannerAsync.when(
      data: (banners) => _buildCarousel(
        context,
        banners.isEmpty ? DefaultBanners.list : banners,
      ),
      loading: () => _buildCarousel(context, DefaultBanners.list),
      error: (err, stack) {
        debugPrint('Banner Error: $err');
        return _buildCarousel(context, DefaultBanners.list);
      },
    );
  }

  Widget _buildCarousel(BuildContext context, List<BannerAd> banners) {
    if (banners.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 0.95,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            final isLocal = banner.imageUrl.startsWith('assets/');

            return GestureDetector(
              onTap: () async {
                if (banner.redirectUrl != null &&
                    banner.redirectUrl!.isNotEmpty) {
                  final url = Uri.parse(banner.redirectUrl!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                  image: DecorationImage(
                    image: isLocal
                        ? AssetImage(banner.imageUrl) as ImageProvider
                        : NetworkImage(banner.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        if (banners.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: banners.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.onSurface.withValues(
                    alpha: _currentIndex == entry.key ? 0.9 : 0.2,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
