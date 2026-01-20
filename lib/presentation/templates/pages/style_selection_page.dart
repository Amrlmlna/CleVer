import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/repositories/template_repository.dart';
import '../../cv/providers/cv_generation_provider.dart';

class StyleSelectionPage extends ConsumerStatefulWidget {
  const StyleSelectionPage({super.key});

  @override
  ConsumerState<StyleSelectionPage> createState() => _StyleSelectionPageState();
}

class _StyleSelectionPageState extends ConsumerState<StyleSelectionPage> {
  String _selectedStyle = 'Modern';

  // Styles loaded from repository


  void _generateCV() {
    ref.read(cvCreationProvider.notifier).setStyle(_selectedStyle);
    // TODO: Trigger AI Generation / Navigation to Preview
    context.push('/create/preview'); // Changed to push to preserve navigation stack
  }

  @override
  Widget build(BuildContext context) {
    final templates = TemplateRepository.getAllTemplates();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Gaya CV'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Pilih template yang paling cocok buat kamu',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: templates.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final template = templates[index];
                final isSelected = template.id == _selectedStyle;
                
                 // Determine icon based on tag/id just for visual variety
                IconData icon;
                if (template.id == 'ATS') {
                   icon = Icons.text_snippet_outlined;
                } else if (template.id == 'Modern') {
                   icon = Icons.design_services_outlined;
                } else if (template.id == 'Creative') {
                   icon = Icons.brush_outlined;
                } else {
                   icon = Icons.article_outlined; // Default
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStyle = template.id;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          size: 32,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                template.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : Colors.grey[600],
                                ),
                              ),
                              if (template.isPremium) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.amber : Colors.amber[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'PREMIUM',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.black : Colors.amber[900],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Colors.white),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateCV,
                child: const Text('Buat CV Sekarang'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
