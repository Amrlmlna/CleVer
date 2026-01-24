import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/hero_section.dart';
import '../widgets/recent_drafts_list.dart';
import '../../templates/widgets/template_gallery_card.dart';
import '../../drafts/providers/draft_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch drafts to conditionally render the section
    final draftsAsync = ref.watch(draftsProvider);
    final hasDrafts = draftsAsync.when(
      data: (drafts) => drafts.isNotEmpty,
      loading: () => false, // Don't show while loading initial
      error: (_, __) => false,
    );

    // Gen Z Modern Layout
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Modern Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Halo,',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[400],
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Siap gapai tujuan profesionalmu?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Hero Section (New CV)
              const HeroSection(),
              const SizedBox(height: 32),

              // Recent Drafts - Only Show if Drafts Exist
              if (hasDrafts) ...[
                _buildSectionHeader(context, 'Draft Terakhir'),
                const SizedBox(height: 16),
                const RecentDraftsList(),
                const SizedBox(height: 32),
              ],

              // Template Gallery (Sneak Peek)
              _buildSectionHeader(context, 'Template Gallery'),
              const SizedBox(height: 16),
              const TemplateGalleryCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
        ),
        const Icon(Icons.arrow_forward, color: Colors.white54, size: 20),
      ],
    );
  }
}
