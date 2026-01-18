import 'package:flutter/material.dart';

class DraftsPage extends StatelessWidget {
  const DraftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: AppBar is provided by MainWrapperPage
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Drafts',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.history_edu, size: 64, color: Colors.grey[300]),
                   const SizedBox(height: 16),
                   Text(
                     'No drafts yet.',
                     style: TextStyle(color: Colors.grey[600]),
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
