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

  final savedSettings = false.obs;
  set setSavedSettings(bool val) {
    savedSettings.value = val;
  }

  Rx<XFile> photo = XFile("").obs;
  set setPhoto(XFile val) => photo.value = val;

  final ImagePicker _picker = ImagePicker();

  final auth = FirebaseAuth.instance;

  final storage = FirebaseStorage.instanceFor();

  var displayController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName ?? "");

  Future<bool> popScope() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (!savedSettings.value) return Future.value(true);

    return await showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning, size: 30),
        title:
            const Text("Сигурни ли сте, че не искате да запазите промените?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Да"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Не"),
          ),
        ],
      ),
    );
  }

  Future<void> selectPhoto() async {
    showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints.tightFor(
        width: double.infinity,
        height: Get.size.height / 4.5,
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 5,
                  width: Get.size.width / 3,
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).dividerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Снимай с камера"),
                  onTap: () async => _capture(ImageSource.camera),
                  tileColor: Colors.transparent,
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text("Избери снимка от галерията"),
                  onTap: () async => _capture(ImageSource.gallery),
                  tileColor: Colors.transparent,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _capture(ImageSource source) async {
    var photo = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (photo != null) {
      setPhoto = photo;
      setSavedSettings = true;
    }
  }

  Future<void> savePhoto() async {
    try {
      var file = File(photo.value.path);

      var ext = p.extension(photo.value.path);

      final storage2 =
          storage.ref().child("/profile_pictures/${auth.currentUser!.uid}$ext");

      storage2.putFile(file);

      auth.currentUser!.updatePhotoURL(await storage2.getDownloadURL());
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

    setSavedSettings = false;
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text("Запазени са промените"),
      ),
    );
  }
}
