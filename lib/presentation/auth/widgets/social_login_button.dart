import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
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
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.black,
                    ),
                  )
                else ...[
                  icon,
                  const SizedBox(width: 12),
                  Text(
                    text.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: AppColors.black,
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
