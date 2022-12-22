import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.popScope(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Настройки на профила'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  fit: StackFit.loose,
                  clipBehavior: Clip.antiAlias,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Obx(
                        () {
                          if (controller.auth.currentUser?.photoURL == null &&
                              controller.photo.value.path.isEmpty) {
                            print(
                                controller.auth.currentUser?.photoURL == null);
                            return const Placeholder(
                              child: SizedBox(
                                height: 200,
                                width: 200,
                              ),
                            );
                          }

                          if (controller.photo.value.path.isEmpty) {
                            return CircleAvatar(
                              radius: 100,
                              foregroundImage: NetworkImage(
                                controller.auth.currentUser?.photoURL ?? "",
                              ),
                            );
                          }

                          return CircleAvatar(
                            radius: 100,
                            foregroundImage: FileImage(
                              File(controller.photo.value.path),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 80,
                      child: IconButton(
                        onPressed: () => controller.selectPhoto(),
                        icon: Icon(Icons.add_a_photo),
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: controller.displayController,
                  onChanged: (value) => controller.setSavedSettings = true,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Obx(
          () => AnimatedSlide(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutExpo,
            offset:
                controller.savedSettings.value ? Offset(0, 0) : Offset(0, 3),
            child: FloatingActionButton(
              onPressed: () => controller.saveSettings(),
              child: const Icon(Icons.save),
            ),
          ),
        ),
      ),
    );
  }
}
