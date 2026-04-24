import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/cv_template.dart';
import './locked_overlay.dart';

class TemplateGridItem extends StatelessWidget {
  final CVTemplate template;
  final bool isSelected;
  final VoidCallback onTap;

  const TemplateGridItem({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: isSelected ? const EdgeInsets.all(4) : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: isSelected
                    ? (template.isPremium ? null : colorScheme.primary)
                    : Colors.transparent,
                gradient: isSelected && template.isPremium
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF000000),
                          Color(0xFF0D1B2A),
                          Color(0xFFD4AF37),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(0),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : [],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(0),
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
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(
                          Icons.error_outline,
                          color: colorScheme.error.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    if (template.supportsPhoto)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _PhotoIconBadge(colorScheme: colorScheme),
                      ),
                    if (template.isLocked)
                      LockedOverlay(
                        isPremium: template.isPremium,
                        requiredCredits: template.requiredCredits,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _TemplateNameLabel(
            template: template,
            isSelected: isSelected,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class _PhotoIconBadge extends StatelessWidget {
  const _PhotoIconBadge({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(
        Icons.add_a_photo_outlined,
        size: 10,
        color: colorScheme.onSurface,
      ),
    );
  }
}

class _TemplateNameLabel extends StatelessWidget {
  const _TemplateNameLabel({
    required this.template,
    required this.isSelected,
    required this.textTheme,
    required this.colorScheme,
  });

  final CVTemplate template;
  final bool isSelected;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            template.name.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: isSelected
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
              letterSpacing: 1.0,
            ),
          ),
        ),
        if (template.isPremium) ...[
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, size: 10, color: Color(0xFFD4AF37)),
        ],
      ],
    );
  }
}
