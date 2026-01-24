import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/template_provider.dart';
import '../../../../domain/entities/cv_template.dart';
import '../../cv/providers/cv_generation_provider.dart';

class TemplateGalleryPage extends ConsumerWidget {
  const TemplateGalleryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templateRepositoryProvider).getAllTemplates();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Gallery'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, // Taller for CV preview aspect
        ),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return _TemplateCard(
            template: template,
            onTap: () {
              // Set style and start flow
              ref.read(cvCreationProvider.notifier).setStyle(template.id);
              context.push('/create/job-input');
            },
          );
        },
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final CVTemplate template;
  final VoidCallback onTap;

  const _TemplateCard({required this.template, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Determine icon based on tag/id just for visual variety since we don't have real images
    IconData icon;
    Color color;
    if (template.id == 'ATS') {
       icon = Icons.text_snippet_outlined;
       color = Colors.blueGrey;
    } else if (template.id == 'Modern') {
       icon = Icons.design_services_outlined;
       color = Colors.blue;
    } else if (template.id == 'Creative') {
       icon = Icons.brush_outlined;
       color = Colors.purple;
    } else {
       icon = Icons.person_outline;
       color = Colors.black87;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail / Icon Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(icon, size: 64, color: color),
                ),
              ),
            ),
            // Info Area
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          template.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (template.isPremium)
                        const Icon(Icons.lock, size: 14, color: Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: template.tags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(t, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
