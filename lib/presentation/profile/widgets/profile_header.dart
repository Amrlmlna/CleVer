import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
           child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor, 
              border: Border.all(
                color: Colors.white.withOpacity(0.2), 
                width: 4
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: Icon(Icons.person, size: 50, color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'MASTER PROFILE',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Isi sekali, generate berkali-kali.',
           style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
      ],
    );
  }
}
