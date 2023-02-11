import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class Themes {
  static ThemeData theme(ColorScheme colors) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      appBarTheme: AppBarTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        centerTitle: true,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        elevation: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        insetPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showCloseIcon: true,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: colors.onInverseSurface,
        contentTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: colors.inverseSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.primaryContainer.withAlpha(20),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
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
      fontFamily: "Inter",
    );
  }
}
