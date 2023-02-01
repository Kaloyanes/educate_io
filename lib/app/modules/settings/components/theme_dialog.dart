import 'package:educate_io/app/services/get_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeDialog extends StatelessWidget {
  ThemeDialog({super.key});

  final themeVal = GetStorageService().getThemeMode();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Сменете темата"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadioListTile(
            enableFeedback: true,
            title: Text("Системна"),
            subtitle: Text(
                "Ако устройството ви е в тъмен режим, то и приложението ще бъде"),
            value: ThemeMode.system,
            selected: themeVal == ThemeMode.system,
            groupValue: themeVal,
            onChanged: (value) =>
                GetStorageService().changeTheme(value ?? ThemeMode.system),
          ),
          RadioListTile(
            enableFeedback: true,
            title: Text("Тъмна"),
            value: ThemeMode.dark,
            selected: themeVal == ThemeMode.dark,
            groupValue: themeVal,
            onChanged: (value) =>
                GetStorageService().changeTheme(value ?? ThemeMode.system),
          ),
          RadioListTile(
            enableFeedback: true,
            title: Text("Светла"),
            value: ThemeMode.light,
            selected: themeVal == ThemeMode.light,
            groupValue: themeVal,
            onChanged: (value) =>
                GetStorageService().changeTheme(value ?? ThemeMode.system),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Ок"),
        ),
      ],
    );
  }
}
