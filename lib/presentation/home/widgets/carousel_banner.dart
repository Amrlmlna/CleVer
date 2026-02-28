import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/banner_provider.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return bannerAsync.when(
      data: (banners) {
        if (banners.isEmpty) return const SizedBox.shrink();

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
                return GestureDetector(
                  onTap: () async {
                    if (banner.redirectUrl != null && banner.redirectUrl!.isNotEmpty) {
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
                      color: isDark ? Colors.grey[900] : Colors.grey[200],
                      border: Border.all(
                        color: isDark ? Colors.white12 : Colors.black12,
                        width: 1,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(banner.imageUrl),
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
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: _currentIndex == entry.key ? 0.9 : 0.2,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        );
      },
      loading: () => Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ),
      ),
      error: (err, stack) {
        debugPrint('Banner Error: $err');
        return const SizedBox.shrink(); // Hide silently on error to not ruin UX
      },
    );
  }
}
