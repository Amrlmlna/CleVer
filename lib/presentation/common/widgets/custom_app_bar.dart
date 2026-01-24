import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  
  const CustomAppBar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      forceMaterialTransparency: true, // Removes scroll shadow for cleaner look
      leading: IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () {
          // TODO: Implement Notifications
        },
      ),
      title: title != null ? Text(title!) : null,
      centerTitle: true,

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
