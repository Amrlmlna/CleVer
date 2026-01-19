import 'package:flutter/material.dart';
import '../../common/widgets/auto_slide_banner.dart';

class DraftsBannerCarousel extends StatelessWidget {
  const DraftsBannerCarousel({super.key});

  final List<Map<String, dynamic>> _bannerData = const [
    {
      'title': 'Go Premium',
      'subtitle': 'Remove all ads and unlock exclusive templates.',
      'tag': 'AD',
      'color': Color(0xFF2C3E50),
    },
    {
      'title': 'Get Noticed Faster',
      'subtitle': 'AI-optimized CVs get 3x more interviews.',
      'tag': 'PRO',
      'color': Color(0xFF34495E),
    },
    {
      'title': 'Unlimited Downloads',
      'subtitle': 'Export as many versions as you need in PDF.',
      'tag': 'FREE',
      'color': Color(0xFF2C3E50),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AutoSlideBanner(
      items: _bannerData,
      height: 140, // Slightly smaller than AI banner
      activeIndicatorColor: const Color(0xFF2C3E50),
      interval: const Duration(seconds: 5),
      itemBuilder: (context, item) {
        return _buildBannerCard(
          title: item['title']! as String,
          subtitle: item['subtitle']! as String,
          tag: item['tag']! as String,
          color: item['color'] as Color,
        );
      },
    );
  }

  Widget _buildBannerCard({required String title, required String subtitle, required String tag, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          // const SizedBox(width: 8),
          // Icon(Icons.star_border, color: Colors.white.withOpacity(0.2), size: 48),
        ],
      ),
    );
  }
}
