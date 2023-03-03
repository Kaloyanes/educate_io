import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GetStorageService {
  final _box = GetStorage("settings");

  Future<void> writeSettings(String key, dynamic value) async =>
      await _box.write(key, value);

  T? read<T>(String key) => _box.read(key);

  ThemeMode getThemeMode() {
    var theme = _box.read<String>("theme");

    printInfo(
      info: theme ?? "mainata vi",
    );
    switch (theme) {
      case "dark":
        return ThemeMode.dark;

      case "light":
        return ThemeMode.light;

      case "system":
      default:
        return ThemeMode.system;
    }
  }

  Future<void> changeTheme(ThemeMode value) async {
    Get.changeThemeMode(value);
    String themeString;
    switch (value) {
      case ThemeMode.light:
        themeString = "light";
        break;

      case ThemeMode.dark:
        themeString = "dark";
        break;

      case ThemeMode.system:
        themeString = "system";
        break;
    }

    await _box.write("theme", themeString);
  }

  Color getColor() {
    var color = Color(_box.read<int>("color") ?? Colors.orange.value);

    printInfo(info: color.toString());

    return color;
  }
}
