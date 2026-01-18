import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cv_creation_provider.dart';

class StyleSelectionPage extends ConsumerStatefulWidget {
  const StyleSelectionPage({super.key});

  @override
  ConsumerState<StyleSelectionPage> createState() => _StyleSelectionPageState();
}

class _StyleSelectionPageState extends ConsumerState<StyleSelectionPage> {
  String _selectedStyle = 'Modern';

  final List<Map<String, String>> _styles = [
    {
      'id': 'ATS',
      'name': 'ATS-Friendly',
      'desc': 'Simple, clean, and optimized for Applicant Tracking Systems.',
      'icon': 'text_snippet_outlined', 
    },
    {
      'id': 'Modern',
      'name': 'Modern',
      'desc': 'Sleek design with subtle accents, great for tech and startups.',
      'icon': 'design_services_outlined',
    },
    {
      'id': 'Creative',
      'name': 'Creative',
      'desc': 'Bold layout and typography for design-focused roles.',
      'icon': 'brush_outlined',
    },
  ];

  void _generateCV() {
    ref.read(cvCreationProvider.notifier).setStyle(_selectedStyle);
    // TODO: Trigger AI Generation / Navigation to Preview
    context.go('/preview'); // Using go to clear stack or push to separate flow
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Style'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select a template for your CV',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _styles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final style = _styles[index];
                final isSelected = style['id'] == _selectedStyle;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStyle = style['id']!;
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
                          // Mapping string to IconData roughly
                          style['id'] == 'ATS'
                              ? Icons.text_snippet_outlined
                              : style['id'] == 'Modern'
                                  ? Icons.design_services_outlined
                                  : Icons.brush_outlined,
                          size: 32,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                style['name']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                style['desc']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : Colors.grey[600],
                                ),
                              ),
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
                child: const Text('Generate CV'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
