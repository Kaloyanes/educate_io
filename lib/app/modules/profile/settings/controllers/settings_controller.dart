import 'dart:io';
import 'dart:typed_data';

import "package:path/path.dart" as p;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SettingsController extends GetxController {
  //TODO: Implement SettingsController

  Rx<XFile> photo = XFile("").obs;
  set setPhoto(XFile val) => photo.value = val;

  final ImagePicker _picker = ImagePicker();

  final auth = FirebaseAuth.instance;

  final storage = FirebaseStorage.instanceFor();

  var displayController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName ?? "");

  Future<void> getPhoto() async {
    Uint8List? photoData =
        await storage.ref().child(auth.currentUser!.uid).getData();

    if (photoData != null) {
      photo.value = XFile.fromData(photoData);
    }
  }

  Future<void> selectPhoto() async {
    showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints.tightFor(
        width: double.infinity,
        height: Get.size.height / 4.2,
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 5,
                width: Get.size.width / 3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Снимай с камера"),
                onTap: () async => capture(ImageSource.camera),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Избери снимка от галерията"),
                onTap: () async => capture(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> capture(ImageSource source) async {
    setPhoto = (await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    ))!;
  }

  Future<void> savePhoto() async {
    try {
      var file = File(photo.value.path);

      var ext = p.extension(photo.value.path);

      final storage2 =
          storage.ref().child("/profile_pictures/${auth.currentUser!.uid}$ext");

      storage2.putFile(file);

      auth.currentUser!.updatePhotoURL(await storage2.getDownloadURL());

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Качена е снимката"),
        ),
      );
    } on Exception catch (e) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  void changeDisplayName() {
    FirebaseAuth.instance.currentUser!
        .updateDisplayName(displayController.text);
  }

  void saveSettings() {
    changeDisplayName();
    savePhoto();

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text("Запазени са промените"),
      ),
    );
  }
}
