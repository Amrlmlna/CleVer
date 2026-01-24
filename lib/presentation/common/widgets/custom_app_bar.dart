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
      actions: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Opens the Drawer of the generic scaffold in MainWrapperPage
            Scaffold.of(context).openDrawer();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
