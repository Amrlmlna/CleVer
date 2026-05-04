import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TemplateCarouselPreview extends StatelessWidget {
  final List<String> previewUrls;
  final String thumbnailUrl;
  final bool supportsPhoto;
  final bool usePhoto;
  final PageController pageController;
  final Function(int) onPageChanged;

  const TemplateCarouselPreview({
    super.key,
    required this.previewUrls,
    required this.thumbnailUrl,
    required this.supportsPhoto,
    required this.usePhoto,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 210 / 297,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: previewUrls.isEmpty ? 1 : previewUrls.length,
            onPageChanged: onPageChanged,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              final imageUrl = previewUrls.isEmpty
                  ? thumbnailUrl
                  : previewUrls[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          ),
          if (previewUrls.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  previewUrls.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (usePhoto ? (index == 1) : (index == 0))
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.2),
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
