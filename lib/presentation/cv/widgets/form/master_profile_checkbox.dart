import 'package:flutter/material.dart';

class MasterProfileCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool isDark;

  const MasterProfileCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: CheckboxListTile(
        title: Text(
          'Update Master Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
        ),
        subtitle: Text(
          'Simpan perubahan ini ke profil utamamu.',
          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey),
        ),
        value: value,
        activeColor: isDark ? Colors.white : Colors.black,
        checkColor: isDark ? Colors.black : Colors.white,
        onChanged: onChanged,
        secondary: Icon(Icons.save_as_outlined, color: isDark ? Colors.white70 : Colors.black54),
      ),
    );
  }
}
