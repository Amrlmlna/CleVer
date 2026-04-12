import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class OnboardingStepScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? footer;
  final bool isContentCentered;
  final bool useShaderMask;
  final bool isLargeHeader;
  final bool animateChildren;

  const OnboardingStepScreen({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.footer,
    this.isContentCentered = true,
    this.useShaderMask = false,
    this.isLargeHeader = true,
    this.animateChildren = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 80), // Intentional top spacing for hierarchy
          Text(
            title,
            style: (isLargeHeader ? AppTextStyles.h2 : AppTextStyles.h4).copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.0,
            ),
            textAlign: TextAlign.left,
          ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 12),
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppTextStyles.bodyLarge.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                height: 1.5,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.left,
            ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
          
          const SizedBox(height: 48),
          
          Expanded(
            child: useShaderMask 
              ? ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.black.withValues(alpha: 0)],
                      stops: const [0.8, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(), // No scroll mimic as requested
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: children.asMap().entries.map((entry) {
                      final child = entry.value;
                      if (!animateChildren) return child;
                      return child.animate(delay: (200 + entry.key * 80).ms).fadeIn().slideX(begin: 0.05, end: 0);
                    }).toList(),
                  ),
                )
              : Column(
                  children: children.asMap().entries.map((entry) {
                    final child = entry.value;
                    if (!animateChildren) return child;
                    return child.animate(delay: (200 + entry.key * 80).ms).fadeIn().slideX(begin: 0.05, end: 0);
                  }).toList(),
                ),
          ),
          
          if (footer != null) ...[
            footer!.animate(delay: 600.ms).fadeIn(),
          ],
        ],
      ),
    );
  }
}

class OnboardingSelectionCard extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isSelected;

  const OnboardingSelectionCard({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: AnimatedScale(
        scale: isSelected ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: isSelected 
                  ? colorScheme.primary.withValues(alpha: 0.12) 
                  : colorScheme.surface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected 
                    ? colorScheme.primary 
                    : colorScheme.onSurface.withValues(alpha: 0.1),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ] : [],
              ),
              child: Row(
                children: [
                   if (icon != null) ...[
                    Icon(
                      icon,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 22,
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Text(
                      text,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  if (isSelected) 
                    Icon(
                      Icons.check_circle_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ).animate().scale(curve: Curves.easeOutBack),
                ],
              ),
            ),
          ).animate(target: isSelected ? 1 : 0).shimmer(
            duration: 1200.ms,
            color: colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
      ),
    );
  }
}
