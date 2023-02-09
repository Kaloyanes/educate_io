import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:educate_io/app/modules/profile_settings/controllers/profile_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class ImageCropView extends StatelessWidget {
  ImageCropView({super.key, required Uint8List imageData})
      : _imageData = imageData;

  final Uint8List _imageData;

  final cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withAlpha(100),
      ),
      body: Crop(
        progressIndicator: const CircularProgressIndicator(),
        initialSize: 0.5,
        image: _imageData,
        controller: cropController,
        onCropped: (value) {
          Get.back(result: value);
        },
        withCircleUi: true,
        baseColor: Theme.of(context).scaffoldBackgroundColor,
        maskColor: Colors.black.withAlpha(100),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          var control = Get.find<ProfileSettingsController>();
          control.setSavedSettings = true;
          cropController.crop();
        },
        icon: const Icon(Icons.save_rounded),
        label: const Text("Запази"),
        elevation: 2,
        heroTag: "saveButton",
      ),
    );
  }
}
