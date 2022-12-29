import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/profile/profile_settings/components/image_crop.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:flutter/services.dart';
import "package:path/path.dart" as p;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsController extends GetxController {
  //TODO: Implement SettingsController

  final savedSettings = false.obs;
  set setSavedSettings(bool val) => savedSettings.value = val;

  Rx<XFile> photo = XFile("").obs;
  set setPhoto(XFile val) => photo.value = val;

  final ImagePicker _picker = ImagePicker();

  final auth = FirebaseAuth.instance;

  final storage = FirebaseStorage.instance;

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
    HapticFeedback.selectionClick();

    showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints.tightFor(
        width: double.infinity,
        height: Get.size.height / 3.9 + Get.mediaQuery.padding.bottom,
      ),
      builder: (context) => _photoBottomSheet(context),
    );
  }

  Future<void> _capture(ImageSource source) async {
    var selectedPhoto = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 60,
    );

    if (selectedPhoto != null) {
      HapticFeedback.lightImpact();
      var photoData = await Get.to<Uint8List>(
        ImageCropper(imageData: await selectedPhoto.readAsBytes()),
        preventDuplicates: true,
      );

      if (photoData == null) return;

      var path = selectedPhoto.path;
      var savePhoto = XFile.fromData(photoData);

      await savePhoto.saveTo(path);

      savePhoto = XFile(path);
      setPhoto = savePhoto;
      inspect(photo.value);
      setSavedSettings = true;
      Get.back();
    }
  }

  Future<void> savePhoto() async {
    HapticFeedback.selectionClick();

    var file = File(photo.value.path);
    var ext = p.extension(photo.value.path);
    try {
      final storage2 =
          storage.ref().child("/profile_pictures/${auth.currentUser!.uid}$ext");

      var task = storage2.putFile(file);

      task.snapshotEvents.listen((event) {
        inspect(event);
      });

      task.whenComplete(() async {
        var url = await storage2.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(auth.currentUser?.uid)
            .update({"photoUrl": url});
      });
    } on FirebaseException catch (e) {
      if (e.code == "object-not-found") return;

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

  void changeDisplayName() {}

  Future<void> deleteProfile() async {
    var user = FirebaseAuth.instance.currentUser!;

    try {
      await FirebaseStorage.instance
          .ref("profile_pictures/${user.uid}")
          .delete();
    } on FirebaseException catch (e) {
      inspect(e);
    }
    await FirebaseFirestore.instance.collection("users").doc(user.uid).delete();
    await user.delete();
    Get.offAllNamed(Routes.HOME);
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

  Container _photoBottomSheet(BuildContext context) {
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
  }
}
