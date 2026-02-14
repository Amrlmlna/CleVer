import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/custom_snackbar.dart';

class ErrorPageArgs {
  final String title;
  final String message;
  final String? technicalDetails;
  final VoidCallback? onRetry;

  const ErrorPageArgs({
    required this.title,
    required this.message,
    this.technicalDetails,
    this.onRetry,
  });
}

class ErrorPage extends StatelessWidget {
  final ErrorPageArgs args;

  const ErrorPage({
    super.key,
    required this.args,
  });

  void _copyToClipboard(BuildContext context) {
    if (args.technicalDetails != null) {
      Clipboard.setData(ClipboardData(text: args.technicalDetails!));
      CustomSnackBar.showSuccess(context, 'Error details copied to clipboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine theme brightness for contrast
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // 1. Icon / Illustration
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 32),

              // 2. Title
              Text(
                args.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Outfit',
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Message
              Text(
                args.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
              
              // 4. Technical Details (Collapsible)
              if (args.technicalDetails != null) ...[
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TECHNICAL DETAILS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                          InkWell(
                            onTap: () => _copyToClipboard(context),
                            child: const Icon(Icons.copy, size: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        args.technicalDetails!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Courier', // Monospace
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // 5. Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                         if (context.canPop()) {
                           context.pop(); 
                         } else {
                           context.go('/'); 
                         }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        foregroundColor: isDark ? Colors.white : Colors.black,
                      ),
                      child: const Text('Go Home'),
                    ),
                  ),
                  
                  if (args.onRetry != null || true) ...[ // Always show Close or Retry if passed?
                     // Actually let's just use Go Home as secondary.
                     // A primary "Try Again" is redundant if we don't have a callback.
                     // But typically error pages are terminal unless we pass a specific retry logic.
                     // For now, let's keep it simple.
                     const SizedBox(width: 0), 
                  ],
                ],
              ),
              const SizedBox(height: 16),
              if (Navigator.of(context).canPop())
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Close'),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
