import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';

class PreviewHeader extends StatelessWidget {
  final UserProfile userProfile;

  const PreviewHeader({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            userProfile.fullName.toUpperCase(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '${userProfile.email} | ${userProfile.phoneNumber ?? ""} | ${userProfile.location ?? ""}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
