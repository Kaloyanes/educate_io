import 'package:educate_io/app/modules/settings/components/color_picker_dialog.dart';
import 'package:educate_io/app/modules/settings/components/theme_dialog.dart';
import 'package:educate_io/app/services/get_storage_service.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final themeVal = GetStorageService().read<String>("theme").obs;

  @override
  void onInit() {
    super.onInit();
    GetStorage("settings").listenKey("theme", (value) {
      themeVal.value = value;
    });
  }

  void changeTheme() => showDialog<ThemeMode>(
        context: Get.context!,
        builder: (context) => ThemeDialog(),
      );

  void changeColor() {
    showDialog(
      context: Get.context!,
      builder: (context) => const ColorPickerDialog(),
    );
  }
}
