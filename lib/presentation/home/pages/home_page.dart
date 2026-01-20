import 'package:flutter/material.dart';
import '../widgets/hero_section.dart';
import '../widgets/recent_drafts_list.dart';
import '../../templates/widgets/template_gallery_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Text(
              'Halo,',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            Text(
              'Siap dapetin kerja impian?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            // Hero Section
            const HeroSection(),
            const SizedBox(height: 32),

            // Recent Drafts
            _buildSectionHeader(context, 'Draft Terakhir'),
            const SizedBox(height: 16),
            const RecentDraftsList(),
            const SizedBox(height: 32),

            // Template Gallery
            const TemplateGalleryCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
    );
  }
}
