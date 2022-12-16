import 'package:flutter/material.dart';

class Themes {
  static ThemeData theme({bool darkMode = false}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: darkMode ? Brightness.dark : Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        centerTitle: true,
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(),
    );
  }
}
