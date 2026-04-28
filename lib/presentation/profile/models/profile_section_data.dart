import 'package:flutter/material.dart';

class ProfileSectionData {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final Color iconBgColor;
  final Color iconColor;
  final Widget child;

  const ProfileSectionData({
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.child,
  });
}
