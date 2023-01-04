import 'dart:developer';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          inspect(value);
          Get.back(result: value);
        },
        baseColor: Theme.of(context).scaffoldBackgroundColor,
        maskColor: Colors.black.withAlpha(100),
        aspectRatio: 4 / 3,
        withCircleUi: true,
        radius: 50,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => cropController.crop(),
        icon: const Icon(Icons.save_rounded),
        label: const Text("Запази"),
        elevation: 2,
        heroTag: "saveButton",
      ),
    );
  }
}
