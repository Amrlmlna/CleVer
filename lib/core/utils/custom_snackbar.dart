import 'package:flutter/material.dart';
import 'dart:ui';

/// Custom SnackBar utilities for consistent app-wide notifications
class CustomSnackBar {
  static OverlayEntry? _currentEntry;

  /// Show a success snackbar
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, Icons.check_circle_outline);
  }

  /// Show an error snackbar
  static void showError(BuildContext context, String message) {
    _show(context, message, Icons.error_outline);
  }

  /// Show an info snackbar
  static void showInfo(BuildContext context, String message) {
    _show(context, message, Icons.info_outline);
  }

  /// Show a warning snackbar
  static void showWarning(BuildContext context, String message) {
    _show(context, message, Icons.warning_amber_rounded);
  }

  static String _normalizeErrorMessage(String errorMsg) {
    if (errorMsg.contains('firebase_auth/email-already-in-use')) {
      return 'This email address is already in use by another account.';
    }
    if (errorMsg.contains('firebase_auth/invalid-credential') ||
        errorMsg.contains('firebase_auth/wrong-password')) {
      return 'Invalid email or password. Please try again.';
    }
    if (errorMsg.contains('firebase_auth/weak-password')) {
      return 'The password provided is too weak.';
    }
    if (errorMsg.contains('firebase_auth/too-many-requests')) {
      return 'Too many login attempts. Please try again later.';
    }
    if (errorMsg.contains('firebase_auth/user-not-found')) {
      return 'No user found with this email address.';
    }
    if (errorMsg.contains('firebase_auth/network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    }

    // Strip out the bracketed Firebase specific error codes if present
    final regex = RegExp(r'\[.*?\] \s*');
    final cleaned = errorMsg.replaceAll(regex, '').trim();

    if (cleaned.startsWith('Exception: ')) {
      return cleaned.substring(11); // Remove leading 'Exception: '
    }
    return cleaned;
  }

  /// Internal method to show styled snackbar
  static void _show(BuildContext context, String message, IconData icon) {
    final sanitizedMessage = _normalizeErrorMessage(message);

    // Remove existing if any
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => _TopSnackBar(
        message: sanitizedMessage,
        icon: icon,
        onDismissed: () {
          _currentEntry?.remove();
          _currentEntry = null;
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}

class _TopSnackBar extends StatefulWidget {
  final String message;
  final IconData icon;
  final VoidCallback onDismissed;

  const _TopSnackBar({
    required this.message,
    required this.icon,
    required this.onDismissed,
  });

  @override
  State<_TopSnackBar> createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<_TopSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    Color statusColor;
    if (widget.icon == Icons.check_circle_outline) {
      statusColor = const Color(0xFFB9D870);
    } else if (widget.icon == Icons.error_outline) {
      statusColor = colorScheme.error;
    } else if (widget.icon == Icons.warning_amber_rounded) {
      statusColor = const Color(0xFFF59E0B);
    } else {
      statusColor = colorScheme.primary;
    }

    return Positioned(
      top: topPadding + 12,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.up,
          onDismissed: (_) {
            widget.onDismissed();
          },
          child: SlideTransition(
            position: _offsetAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.message.toUpperCase(),
                            style: TextStyle(
                              color: colorScheme.surface,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          widget.icon,
                          color: colorScheme.surface.withValues(alpha: 0.7),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
