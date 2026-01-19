import 'package:flutter/material.dart';
import '../../ads/widgets/ai_banner_carousel.dart';
import '../widgets/ai_tool_card.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'AI Tools',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Supercharge your job search with AI.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Auto-Sliding Banner
          const AIBannerCarousel(),
          const SizedBox(height: 32),

          // Tools Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: const [
                AIToolCard(
                  icon: Icons.description_outlined,
                  title: 'Resume Scanner',
                  desc: 'Match vs Job Desc',
                ),
                AIToolCard(
                  icon: Icons.auto_fix_high_outlined,
                  title: 'Cover Letter',
                  desc: 'Auto-write & Edit',
                ),
                AIToolCard(
                  icon: Icons.share_outlined,
                  title: 'LinkedIn Opt',
                  desc: 'Profile Enhancer',
                ),
                AIToolCard(
                  icon: Icons.mic_none_outlined,
                  title: 'Interview Prep',
                  desc: 'AI Voice Coach',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
