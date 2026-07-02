import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = "isDarkMode";

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_themeKey)) {
      _themeMode = ThemeMode.system;
    } else {
      final isDark = prefs.getBool(_themeKey) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      await prefs.setBool(_themeKey, false);
    } else {
      _themeMode = ThemeMode.dark;
      await prefs.setBool(_themeKey, true);
    }

    notifyListeners();
  }

  Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;

    await prefs.setBool(_themeKey, enabled);

    notifyListeners();
  }

  Future<void> setSystemTheme() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_themeKey);

    _themeMode = ThemeMode.system;

    notifyListeners();
  }
}