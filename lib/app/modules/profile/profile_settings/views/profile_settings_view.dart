import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:educate_io/app/services/database/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                profilePicture(),
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
                Expanded(child: Container()),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.red),
                    overlayColor:
                        MaterialStatePropertyAll(Colors.red.withAlpha(20)),
                  ),
                  onPressed: () => controller.deleteProfile(),
                  child: Text("Изтрий профила"),
                ),
                SizedBox(height: Get.mediaQuery.padding.bottom),
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

  Stack profilePicture() {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.loose,
      clipBehavior: Clip.antiAlias,
      children: [
        Align(
          alignment: Alignment.center,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) => FutureBuilder(
              future: FirestoreService.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Obx(() {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData ||
                      snapshot.hasError) {
                    return const CircularProgressIndicator();
                  }

                  if (controller.photo.value.path != "") {
                    return CircleAvatar(
                      radius: 100,
                      foregroundImage: FileImage(
                        File(controller.photo.value.path),
                      ),
                    );
                  }

                  var data = snapshot.data;

                  Widget child = CircleAvatar(
                    radius: 100,
                    child: Text(
                      data!["initials"] ?? "",
                      style: TextStyle(fontSize: 60),
                    ),
                  );

                  if (data["photoUrl"]?.isNotEmpty ?? false) {
                    child = CircleAvatar(
                      radius: 100,
                      foregroundImage:
                          CachedNetworkImageProvider(data["photoUrl"] ?? ""),
                    );
                  }

                  return child;
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 70,
          child: IconButton(
            onPressed: () => controller.selectPhoto(),
            icon: Icon(Icons.add_a_photo),
            iconSize: 30,
          ),
        ),
      ],
    );
  }
}
