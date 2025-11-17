import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme mode notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _key = 'theme_mode';

  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadThemeMode();
  }

  // Load theme mode from shared preferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_key);
    
    if (themeModeString != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeString,
        orElse: () => ThemeMode.light,
      );
    }
  }

  // Toggle theme mode
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.toString());
  }

  // Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  // Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  // Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  // Check if dark mode
  bool get isDarkMode => state == ThemeMode.dark;

  // Check if light mode
  bool get isLightMode => state == ThemeMode.light;
}

// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

// Is dark mode provider
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.dark;
});

// Is light mode provider
final isLightModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.light;
});
