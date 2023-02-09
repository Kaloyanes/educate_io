import 'package:educate_io/app/services/get_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  final dynamicColor = false.obs;

  @override
  void onInit() {
    super.onInit();
    dynamicColor.value = GetStorageService().read<bool>("dynamic") ?? false;
  }

  var lightColor = ColorScheme.fromSeed(
          seedColor: GetStorageService().getColor(),
          brightness: Brightness.light)
      .obs;

  var darkColor = ColorScheme.fromSeed(
          seedColor: GetStorageService().getColor(),
          brightness: Brightness.dark)
      .obs;
}
