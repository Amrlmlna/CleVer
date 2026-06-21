import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  static const String _key = 'theme_mode';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_key);

    if (savedMode != null) {
      if (savedMode == 'light') {
        state = ThemeMode.light;
      } else if (savedMode == 'dark') {
        state = ThemeMode.dark;
      } else {
        state = ThemeMode.system;
      }
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((
  ref,
) {
  return ThemeNotifier();
});
