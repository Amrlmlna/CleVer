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

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth =
            constraints.maxWidth * pageController.viewportFraction;
        final cardWidth = viewportWidth - 24;
        final cardHeight = cardWidth * (1123 / 794);

        return SizedBox(
          height: cardHeight + 40,
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
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 794 / 1123,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.5,
                              ),
                              width: 1.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.fill,
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
                      ),
                    ),
                  );
                },
              ),
              if (previewUrls.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(previewUrls.length, (index) {
                      final isActive = usePhoto ? (index == 1) : (index == 0);
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isActive
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.15),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
