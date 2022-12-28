import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_settings_controller.dart';

class ProfileSettingsView extends GetView<ProfileSettingsController> {
  const ProfileSettingsView({Key? key}) : super(key: key);
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
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
          child: SafeArea(
            bottom: false,
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
                      child: FutureBuilder(
                        future: controller.futurePhoto,
                        builder: (context, snapshot) => Obx(
                          () {
                            if (!snapshot.hasData &&
                                controller.photo.value.path.isEmpty) {
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
                                foregroundImage: CachedNetworkImageProvider(
                                  snapshot.data ?? "",
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
                    ),
                    Positioned(
                      bottom: 5,
                      right: 60,
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
