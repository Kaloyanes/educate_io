import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки на профила'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: controller.displayController,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => controller.selectPhoto(),
              child: const Text("Change picture"),
            ),
            Obx(() {
              if (controller.auth.currentUser?.photoURL == null &&
                  controller.photo.value.path.isEmpty) {
                print(controller.auth.currentUser?.photoURL == null);
                print(controller.photo.value == null);
                return Placeholder(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                  ),
                );
              }

              if (controller.photo.value.path.isEmpty &&
                  controller.auth.currentUser?.photoURL != null) {
                return CachedNetworkImage(
                    imageUrl: controller.auth.currentUser?.photoURL ?? "");
              }

              return Image.file(
                width: 200,
                height: 400,
                File(controller.photo.value.path),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.saveSettings(),
        child: const Icon(Icons.save),
      ),
    );
  }
}
