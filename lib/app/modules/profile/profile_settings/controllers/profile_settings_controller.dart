import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/profile/profile_settings/components/photo_bottom_sheet.dart';
import 'package:educate_io/app/modules/profile/profile_settings/views/image_crop_view.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:flutter/services.dart';
import "package:path/path.dart" as p;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ProfileSettingsController extends GetxController {
  //TODO: Implement SettingsController

  final savedSettings = false.obs;
  set setSavedSettings(bool val) => savedSettings.value = val;

  final deletePhoto = false.obs;
  set delPhoto(bool val) => deletePhoto.value = val;

  Rx<XFile> photo = XFile("").obs;
  set setPhoto(XFile val) => photo.value = val;

  final ImagePicker _picker = ImagePicker();

  final auth = FirebaseAuth.instance;

  final storage = FirebaseStorage.instance;

  final store = FirebaseFirestore.instance;

  var displayController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName ?? "");

  Future<bool> exitPage() async {
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

    var imageSource = await showModalBottomSheet<String>(
      context: Get.context!,
      builder: (context) => const PhotoBottomSheet(),
      isScrollControlled: true,
    );

    if (imageSource == null) return;

    if (imageSource == "delete") {
      delPhoto = true;
      return;
    }

    _capture(
        imageSource == "camera" ? ImageSource.camera : ImageSource.gallery);
  }

  Uint8List _fixOrientation(Uint8List imageBytes) {
    img.Image? originalImage = img.decodeImage(imageBytes);
    img.Image fixedImage = img.flipVertical(originalImage!);

    return img.encodeJpg(fixedImage);
  }

  Future<void> _capture(ImageSource source) async {
    var selectedPhoto = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 99,
    );

    if (selectedPhoto != null) {
      HapticFeedback.lightImpact();
      var photoData = await Get.to<Uint8List>(
        ImageCropView(imageData: await selectedPhoto.readAsBytes()),
        preventDuplicates: true,
      );

      if (photoData == null) return;
      setSavedSettings = true;

      var path = selectedPhoto.path;
      var savePhoto = XFile.fromData(photoData);

      await savePhoto.saveTo(path);

      savePhoto = XFile(path);
      setPhoto = savePhoto;
    }
  }

  Future<void> savePhoto() async {
    HapticFeedback.selectionClick();
    print("Saving photo");

    var file = File(photo.value.path);
    var ext = p.extension(photo.value.path);
    try {
      final storage2 =
          storage.ref().child("/profile_pictures/${auth.currentUser!.uid}$ext");

      var task = storage2.putFile(file);

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

  Future<void> deletePhotoSetting() async {
    print("deleting photo");
    var doc = store.collection("users").doc(auth.currentUser?.uid);
    var getDoc = await doc.get();

    if (getDoc.data()!.containsKey("photoUrl")) {
      setPhoto = XFile("");
      await store.collection("users").doc(auth.currentUser?.uid).update({
        "photoUrl": "",
      });
    }
  }

  void saveSettings() {
    changeDisplayName();
    if (deletePhoto.value) {
      deletePhotoSetting();
    } else {
      savePhoto();
    }

    setSavedSettings = false;
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text("Запазени са промените"),
      ),
    );
  }

  @override
  void onClose() {
    setPhoto = XFile("");
    setSavedSettings = false;
    super.onClose();
  }
}
