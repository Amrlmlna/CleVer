import 'package:flutter/material.dart';

/// Custom SnackBar utilities for consistent app-wide notifications
class CustomSnackBar {
  /// Show a success snackbar
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: Colors.green.shade900,
      borderColor: Colors.green,
    );
  }

  /// Show an error snackbar
  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.error,
      backgroundColor: Colors.red.shade900,
      borderColor: Colors.red,
    );
  }

  /// Show an info snackbar
  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info,
      backgroundColor: Colors.grey.shade900,
      borderColor: Colors.white,
    );
  }

  /// Show a warning snackbar
  static void showWarning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.warning,
      backgroundColor: Colors.orange.shade900,
      borderColor: Colors.orange,
    );
  }

  /// Internal method to show styled snackbar
  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: borderColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.up,
      ),
    );
  }
}
