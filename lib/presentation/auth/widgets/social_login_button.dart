import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget icon;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.onSurface,
                    ),
                  )
                else ...[
                  icon,
                  const SizedBox(width: 12),
                  Text(
                    text.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: colorScheme.onSurface,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
