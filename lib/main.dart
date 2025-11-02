import 'package:flutter/material.dart';
import 'package:msp_mobile/screens/home_screen.dart';
import 'package:theme_provider/theme_provider.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme(
          id: "light",
          description: "Light Theme",
          data: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFFE7000B), 
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
        ),
        AppTheme(
          id: "dark", 
          description: "Dark Theme",
          data: ThemeData(
           colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFFE7000B), // <-- Correct format
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
        ),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            title: 'Faith Stream',
            theme: ThemeProvider.themeOf(themeContext).data,
            home: const MyHomePage(title: 'Faith Stream'),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}

