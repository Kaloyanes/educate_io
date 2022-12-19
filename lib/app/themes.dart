import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(colors.background),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: colors.primary,
          ),
        ),
      ),
      // textTheme: GoogleFonts.robotoTextTheme(),
    );
  }
}
