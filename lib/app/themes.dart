import 'package:flutter/material.dart';

class Themes {
  static ThemeData theme(ColorScheme colors, {bool darkMode = false}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors.copyWith(
          // background: darkMode ? Colors.black : Colors.white,
          ),
      appBarTheme: AppBarTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        centerTitle: true,
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.transparent),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.primaryContainer.withAlpha(10),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: colors.primary,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      splashFactory: InkSplash.splashFactory,
    );
  }
}
