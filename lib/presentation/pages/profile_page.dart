import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'User Name', // Placeholder
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Text(
              'user@example.com', // Placeholder
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            _buildProfileItem(Icons.person_outline, 'Personal Information'),
            _buildProfileItem(Icons.work_outline, 'Experience'),
            _buildProfileItem(Icons.school_outlined, 'Education'),
            _buildProfileItem(Icons.code, 'Skills'),
            const Divider(height: 48),
            _buildProfileItem(Icons.logout, 'Log Out', isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black,
          fontWeight: isDestructive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isDestructive ? null : const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Navigate to detail
      },
    );
  }
}
