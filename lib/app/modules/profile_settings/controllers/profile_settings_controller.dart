import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/profile_settings/components/photo_bottom_sheet.dart';
import 'package:educate_io/app/modules/profile_settings/views/image_crop_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import "package:path/path.dart" as p;

class ProfileSettingsController extends GetxController {
  final savedSettings = false.obs;

  set setSavedSettings(bool val) => savedSettings.value = val;

  final deletePhoto = false.obs;

  set delPhoto(bool val) => deletePhoto.value = val;

  Rx<XFile> photo = XFile("").obs;

  set setPhoto(XFile val) => photo.value = val;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final store = FirebaseFirestore.instance;

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

    var file = File(photo.value.path);
    if (!file.existsSync()) return;

    var ext = p.extension(photo.value.path);
    try {
      final ref = storage.ref("/profile_pictures/${auth.currentUser!.uid}$ext");

      var task = ref.putFile(file);

      task.whenComplete(() async {
        var url = await ref.getDownloadURL();
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

  Future<void> deletePhotoSetting() async {
    var doc = store.collection("users").doc(auth.currentUser?.uid);
    var getDoc = await doc.get();

    if (getDoc.data()!.containsKey("photoUrl")) {
      setPhoto = XFile("");
      await store.collection("users").doc(auth.currentUser?.uid).update({
        "photoUrl": "",
      });
    }
  }

  Future<void> saveSettings() async {
    saveInfo();
    if (deletePhoto.value) {
      deletePhotoSetting();
    } else {
      savePhoto();
    }
    Get.appUpdate();

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

  @override
  void onInit() {
    super.onInit();
    getInfo();
  }

  final showRoleSettings = false.obs;

  final displayNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final role = "".obs;
  final subjectController = TextEditingController();
  final badSubjectController = TextEditingController();
  final showProfile = false.obs;

  final subjects = <String>[].obs;

  set addSubject(String val) => subjects.add(val.capitalizeFirst!);

  final badSubjects = <String>[].obs;

  set addbadSubject(String val) => badSubjects.add(val.capitalizeFirst!);

  final Rx<LatLng?> currentLocation = null.obs;

  Future<void> getInfo() async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get();

    var data = doc.data();

    displayNameController.text = data!["name"];
    descriptionController.text = data["description"] ?? "";
    phoneController.text = (data["phone"] as String).substring(4);
    emailController.text = data["email"];
    role.value = data["role"];
    showProfile.value = data["showProfile"] as bool;
    subjects.value =
        List.castFrom<dynamic, String>(data["subjects"] as List<dynamic>);

    if (data.containsKey("badSubjects")) {
      badSubjects.value =
          List.castFrom<dynamic, String>(data["badSubjects"] as List<dynamic>);
    }
    showRoleSettings.value = true;

    var locDoc = await FirebaseFirestore.instance
        .collection("locations")
        .doc(auth.currentUser!.uid)
        .get();

    var locationData = locDoc.data() ?? {};

    if (locationData.containsKey("position")) {
      var geo = locationData["position"] as GeoPoint;

      currentLocation.value = LatLng(geo.latitude, geo.longitude);
    }
  }

  Future<void> saveInfo() async {
    var doc = FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid);

    var data = {
      "name": displayNameController.text.trim().capitalize,
      "description": descriptionController.text.trim(),
      "phone": "+359${phoneController.text.trim()}",
      "showProfile": showProfile.value,
      "subjects": subjects
    };

    if (badSubjects.isNotEmpty) data.addAll({"badSubjects": badSubjects});

    var email = emailController.text.trim();
    if (email != auth.currentUser!.email) {
      data.addAll({"email": email});
      auth.currentUser!.updateEmail(email);
    }

    doc.update(data);
  }

  Future<void> forgotPassword() async {
    auth.sendPasswordResetEmail(email: auth.currentUser!.email ?? "");

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        content: Text(
          "Погледнете си имейла",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  Column teacherSettings() {
    return Column(
      children: [
        TextFormField(
          controller: subjectController,
          decoration: InputDecoration(
            label: const Text(
              "Предмети",
            ),
            hintText: "Програмиране",
            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                if (subjectController.text.isNotEmpty) {
                  addSubject = subjectController.text;
                  subjectController.clear();
                  return;
                }

                throw Exception("Category text is empty");
              },
            ),
            prefixIcon: const Icon(Icons.menu_book),
          ),
          validator: (value) {
            if (subjects.isEmpty) {
              return "Добави категория";
            }

            return null;
          },
        ),
        Obx(() {
          return ReorderableListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: subjects.length,
            itemBuilder: (context, index) => ListTile(
              key: Key("$index"),
              contentPadding: EdgeInsets.zero,
              title: Text(subjects[index]),
              leading: IconButton(
                icon: const Icon(
                  Icons.remove,
                  color: Colors.red,
                ),
                onPressed: () => subjects.removeAt(index),
              ),
              trailing: ReorderableDragStartListener(
                index: index,
                child: const Icon(
                  Icons.drag_handle,
                ),
              ),
            ),
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = subjects.removeAt(oldIndex);
              subjects.insert(newIndex, item);
            },
          );
        }),
      ]
          .animate(
            interval: 150.ms,
          )
          .scaleXY(duration: 600.ms, curve: Curves.easeOut, delay: 600.ms),
    );
  }

  Column studentSettings() {
    return Column(children: [
      Obx(
        () => SwitchListTile(
          value: showProfile.value,
          onChanged: (val) {
            setSavedSettings = true;
            showProfile.value = val;
          },
          title: const Text("Да се показва ли профила на други ученици?"),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      TextFormField(
        controller: subjectController,
        onFieldSubmitted: (value) {
          addSubject = value;
          subjectController.clear();
        },
        decoration: InputDecoration(
          label: const Text(
            "Предмети по които си добър",
          ),
          hintText: "Програмиране",
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              if (subjectController.text.isNotEmpty) {
                addSubject = subjectController.text.trim();
                subjectController.clear();
                return;
              }

              throw Exception("Category text is empty");
            },
          ),
          prefixIcon: const Icon(CupertinoIcons.check_mark),
        ),
        validator: (value) {
          if (subjects.isEmpty && showProfile.value) {
            return "Добави 1 предмет в който си добър";
          }

          return null;
        },
      ),
      if (subjects.isNotEmpty)
        ReorderableListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: subjects.length,
          itemBuilder: (context, index) => reorderableTile(index, subjects),
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = subjects.removeAt(oldIndex);
            subjects.insert(newIndex, item);
            setSavedSettings = true;
          },
        ),
      const SizedBox(
        height: 15,
      ),
      TextFormField(
        controller: badSubjectController,
        onFieldSubmitted: (value) {
          addbadSubject = value;
          badSubjectController.clear();
        },
        decoration: InputDecoration(
          label: const Text(
            "Предмети по които НЕ си добър",
          ),
          hintText: "Програмиране",
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              if (badSubjectController.text.isNotEmpty) {
                addbadSubject = badSubjectController.text;
                badSubjectController.clear();
                return;
              }

              throw Exception("Category text is empty");
            },
          ),
          prefixIcon: const Icon(CupertinoIcons.xmark),
        ),
        validator: (value) {
          if (badSubjects.isEmpty && showProfile.value) {
            return "Добави 1 предмет в който не си добър";
          }

          return null;
        },
      ),
      if (badSubjects.isNotEmpty)
        ReorderableListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: badSubjects.length,
          itemBuilder: (context, index) => reorderableTile(index, badSubjects),
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = badSubjects.removeAt(oldIndex);
            badSubjects.insert(newIndex, item);
            setSavedSettings = true;
          },
        ),
    ]);
  }

  Widget reorderableTile(int index, List subjects) {
    return ListTile(
      key: Key("$index"),
      contentPadding: EdgeInsets.zero,
      title: Text(subjects[index]),
      leading: IconButton(
        icon: const Icon(
          Icons.remove,
          color: Colors.red,
        ),
        onPressed: () => subjects.removeAt(index),
      ),
      trailing: ReorderableDragStartListener(
        index: index,
        child: const Icon(
          Icons.drag_handle,
        ),
      ),
    );
  }

  Future<void> updateLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();

    var locationDoc = store.collection("locations").doc(auth.currentUser!.uid);

    locationDoc.set({
      "place": GeoPoint(position.latitude, position.longitude),
    });
  }
}
