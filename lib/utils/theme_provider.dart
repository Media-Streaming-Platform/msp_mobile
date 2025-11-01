import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  // Define your custom colors
  static const Color _lightPrimary = Colors.deepPurple;
  static const Color _darkPrimary = Colors.deepPurpleAccent;
  static const Color _lightBackground = Colors.white;
  static const Color _darkBackground = Color(0xFF121212);

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _lightPrimary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: _lightBackground,
    useMaterial3: true,
  );

  ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _darkPrimary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: _darkBackground,
    useMaterial3: true,
  );
}