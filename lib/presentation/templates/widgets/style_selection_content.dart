import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/cv_template.dart';

class StyleSelectionContent extends StatelessWidget {
  final List<CVTemplate> templates;
  final String selectedStyleId;
  final String selectedLanguage;
  final ValueChanged<String> onStyleSelected;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onExport;

  const StyleSelectionContent({
    super.key,
    required this.templates,
    required this.selectedStyleId,
    required this.selectedLanguage,
    required this.onStyleSelected,
    required this.onLanguageChanged,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SELECT TEMPLATE',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Language Selection (Minimalist)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LanguageButton(
                  label: 'ID',
                  isSelected: selectedLanguage == 'id',
                  onTap: () => onLanguageChanged('id'),
                ),
                const SizedBox(width: 16),
                _LanguageButton(
                  label: 'EN',
                  isSelected: selectedLanguage == 'en',
                  onTap: () => onLanguageChanged('en'),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7, // Aspect ratio for A4-ish preview + text
                crossAxisSpacing: 20,
                mainAxisSpacing: 24,
              ),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                final isSelected = template.id == selectedStyleId;
                
                return GestureDetector(
                  onTap: () => onStyleSelected(template.id),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.transparent,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(0), // Sharp corners for modern look
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 15,
                                      offset: const Offset(0, 10),
                                    )
                                  ]
                                : [],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: CachedNetworkImage(
                              imageUrl: template.thumbnailUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                              ),
                              errorWidget: (context, url, error) => const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.description_outlined, color: Colors.grey, size: 32),
                                    SizedBox(height: 4),
                                    Text("Preview", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        template.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                          color: isSelected ? Colors.black : Colors.grey[600],
                          letterSpacing: 0.5,
                        ),
                      ),
                       if (template.isPremium) ...[
                        const SizedBox(height: 4),
                        Text(
                          'PREMIUM',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onExport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Sharp button
                    ),
                  ),
                  child: const Text(
                    'EXPORT PDF',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
