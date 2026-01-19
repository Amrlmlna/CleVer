import 'package:flutter/material.dart';
import '../../common/widgets/auto_slide_banner.dart';

class AIBannerCarousel extends StatelessWidget {
  const AIBannerCarousel({super.key});

  final List<Map<String, dynamic>> _bannerData = const [
    {
      'title': 'Unlock Premium Features',
      'subtitle': 'Get unlimited AI scans and advanced templates.',
      'image': 'assets/banner_1.png', 
      'color': Colors.black, // or adjust logic to be passed differently if needed
    },
    {
      'title': 'New: Cover Letter Gen',
      'subtitle': 'Write the perfect cover letter in seconds.',
      'image': 'assets/banner_2.png',
      // Using a different shade for variety if needed, or stick to logic
       'color': Color(0xFF212121), // Colors.grey[900]
    },
    {
      'title': 'Ace Your Interview',
      'subtitle': 'Practice with our new AI voice coach.',
      'image': 'assets/banner_3.png',
      'color': Colors.black,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AutoSlideBanner(
      items: _bannerData,
      interval: const Duration(seconds: 4),
      itemBuilder: (context, item) {
        return _buildBannerCard(
          title: item['title']! as String,
          subtitle: item['subtitle']! as String,
          color: item['color'] as Color,
        );
      },
    );
  }

  Widget _buildBannerCard({required String title, required String subtitle, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
          Icon(Icons.auto_awesome, color: Colors.white.withValues(alpha: 0.3), size: 64),
        ],
      ),
    );
  }
}
