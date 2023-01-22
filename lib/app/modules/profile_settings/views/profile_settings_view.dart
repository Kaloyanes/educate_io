import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:educate_io/app/services/database/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/profile_settings_controller.dart';

class ProfileSettingsView extends GetView<ProfileSettingsController> {
  const ProfileSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.exitPage(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Настройки на профила'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profilePicture(),
              const SizedBox(
                height: 20,
              ),
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: controller.formKey,
                child: Column(
                  children: [
                    profileTextField(
                      label: "Име",
                      controller: controller.displayNameController,
                      profileController: controller,
                    ),
                    const SizedBox(height: 15),
                    profileTextField(
                      label: "Описание",
                      controller: controller.descriptionController,
                      profileController: controller,
                    ),
                    const SizedBox(height: 15),
                    profileTextField(
                      addedDecoration: InputDecoration(prefixText: "+359"),
                      label: "Телефон",
                      type: TextInputType.phone,
                      controller: controller.phoneController,
                      profileController: controller,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                          9,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    profileTextField(
                      label: "Имейл",
                      controller: controller.emailController,
                      profileController: controller,
                      validator: (value) {
                        if (!value.isEmail) {
                          return "Невалиден имейл";
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    Obx(() {
                      switch (controller.role.value) {
                        case "teacher":
                          return controller.teacherSettings();

                        case "student":
                          return controller.studentSettings();

                        default:
                          return Container();
                      }
                    }),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuthService.forgotPassword(
                      controller.emailController.text);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Проверете си имейла")));
                },
                child: const Text("Промени паролата"),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red),
                  overlayColor:
                      MaterialStatePropertyAll(Colors.red.withAlpha(20)),
                ),
                onPressed: () {},
                child: const Text("Изтрий профила"),
              ),
              SizedBox(height: Get.mediaQuery.padding.bottom),
            ],
          ),
        ),
        floatingActionButton: Obx(
          () => AnimatedSlide(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutExpo,
            offset: controller.savedSettings.value
                ? const Offset(0, 0)
                : const Offset(0, 3),
            child: FloatingActionButton(
              onPressed: () => controller.saveSettings(),
              heroTag: "saveButton",
              child: const Icon(Icons.save),
            ),
          ),
        ),
      ),
    );
  }

  Widget profileTextField({
    required String label,
    required TextEditingController controller,
    required ProfileSettingsController profileController,
    InputDecoration addedDecoration = const InputDecoration(),
    TextInputType type = TextInputType.text,
    List<TextInputFormatter> formatters = const [],
    bool canBeEmpty = false,
    String? Function(String)? validator,
  }) {
    return TextFormField(
      decoration: addedDecoration.copyWith(
        label: Text(label),
      ),
      inputFormatters: formatters,
      controller: controller,
      onChanged: (value) => profileController.setSavedSettings = true,
      keyboardType: type,
      validator: (value) {
        if (!canBeEmpty) {
          if (value == null || value.isEmpty) {
            return "Попъленете полето";
          }
        }

        if (validator != null) return validator(value ?? "");

        return null;
      },
    );
  }

  Widget profilePicture() {
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
              future: FirestoreProfileService.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData ||
                    snapshot.hasError) {
                  return const CircularProgressIndicator();
                }

                return Obx(() {
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
                      style: const TextStyle(fontSize: 60),
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
        SizedBox(
          height: MediaQuery.of(Get.context!).size.height / 4.5,
          width: 212,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(Get.context!)
                    .scaffoldBackgroundColor
                    .withAlpha(100),
                borderRadius: BorderRadius.circular(360),
              ),
              child: IconButton(
                onPressed: () => controller.selectPhoto(),
                icon: const Icon(Icons.add_a_photo),
                iconSize: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
