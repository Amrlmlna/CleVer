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
          
          // Language Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bahasa CV:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                SegmentedButton<String>(
                  segments: const [
                     ButtonSegment(value: 'id', label: Text('Indonesia'), icon: Icon(Icons.flag)),
                     ButtonSegment(value: 'en', label: Text('Inggris'), icon: Icon(Icons.language)),
                  ],
                  selected: {ref.watch(cvCreationProvider).language},
                  onSelectionChanged: (Set<String> newSelection) {
                    ref.read(cvCreationProvider.notifier).setLanguage(newSelection.first);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

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
                      color: isSelected ? Colors.white : const Color(0xFF1E1E1E), 
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
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
                          color: isSelected ? Colors.black : Colors.white,
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
                                  color: isSelected ? Colors.black : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                template.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
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
                          const Icon(Icons.check_circle, color: Colors.black),
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
