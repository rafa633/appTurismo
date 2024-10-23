import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadThemePreference();
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemePreference();
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('theme');
    _themeMode = (theme == 'dark') ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', _themeMode == ThemeMode.dark ? 'dark' : 'light');
  }
}
