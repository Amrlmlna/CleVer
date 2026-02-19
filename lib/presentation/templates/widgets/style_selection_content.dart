import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/cv_template.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class StyleSelectionContent extends StatelessWidget {
  final List<CVTemplate> templates;
  final String selectedStyleId;
  final ValueChanged<String> onStyleSelected;
  final VoidCallback onExport;

  const StyleSelectionContent({
    super.key,
    required this.templates,
    required this.selectedStyleId,
    required this.onStyleSelected,
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
        title: Text(
          AppLocalizations.of(context)!.selectTemplate,
          style: const TextStyle(
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
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: template.thumbnailUrl,
                                cacheKey: template.id,
                                fit: BoxFit.cover,
                                memCacheHeight: 600,
                                maxHeightDiskCache: 800,
                                fadeInDuration: const Duration(milliseconds: 200),
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(Icons.error_outline, color: Colors.red.withValues(alpha: 0.5)),
                                ),
                              ),
                              if (template.isLocked)
                                Container(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.lock_rounded, color: Colors.white, size: 32),
                                        const SizedBox(height: 8),
                                        Text(
                                          AppLocalizations.of(context)!.premium,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
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
                          AppLocalizations.of(context)!.premium,
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
                  child: Text(
                    AppLocalizations.of(context)!.exportPdf,
                    style: const TextStyle(
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


