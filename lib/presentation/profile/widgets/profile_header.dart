import 'package:flutter/material.dart';

import 'dart:io';

class ProfileHeader extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onEditImage;

  const ProfileHeader({super.key, this.imagePath, this.onEditImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
           child: Stack(
             children: [
               GestureDetector(
                 onTap: onEditImage,
                 child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor, 
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2), 
                      width: 4
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
                    ],
                    image: imagePath != null 
                        ? DecorationImage(
                            image: FileImage(File(imagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imagePath == null 
                      ? Icon(Icons.person, size: 50, color: Theme.of(context).scaffoldBackgroundColor) 
                      : null,
                               ),
               ),
               Positioned(
                 right: 0,
                 bottom: 0,
                 child: GestureDetector(
                   onTap: onEditImage,
                   child: Container(
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       color: Theme.of(context).colorScheme.primary,
                       shape: BoxShape.circle,
                       border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                     ),
                     child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                   ),
                 ),
               ),
             ],
           ),
        ),
        const SizedBox(height: 16),
        Text(
          'MASTER PROFILE',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Theme.of(context).colorScheme.onSurface,
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
