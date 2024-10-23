import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart'; // Importar a HomePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  MyApp() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool('darkTheme') ?? false;
    themeNotifier.value = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _saveThemePreference(bool isDarkTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', isDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Rota de Turismo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(
              color: Colors.blueGrey[800],
            ),
            cardColor: Colors.grey[850],
            textTheme: TextTheme(
              displayLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white70),
            ),
          ),
          themeMode: themeMode,
          home: HomePage(themeNotifier: themeNotifier), // Passando o themeNotifier para HomePage
        );
      },
    );
  }
}
