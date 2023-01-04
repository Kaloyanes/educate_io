import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GoogleDataController extends GetxController {
  //TODO: Implement GoogleDataController

  final GlobalKey<FormState> formKey = GlobalKey();

  final formatter = DateFormat.yMd("bg");

  final showPassword = false.obs;
  set setPasswordVisibility(val) => showPassword.value = val;

  final role = "".obs;
  set setRole(val) => role.value = val;

  final birthDate = DateTime.now().obs;
  set setBirthDate(date) => birthDate.value = date;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final birthDayController = TextEditingController(
    text: DateFormat.yMd("bg").format(
      DateTime.now(),
    ),
  );

  Future<void> changeDate() async {
    FocusScope.of(Get.context!).requestFocus(new FocusNode());
    var date = DateTime.now();
    setBirthDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime(date.year, 1, 1),
      firstDate: DateTime(1950),
      lastDate: date,
      cancelText: "Отказ",
      errorFormatText: "Грешка",
      errorInvalidText: "Грешка",
      initialDatePickerMode: DatePickerMode.year,
      fieldLabelText: "Избери дата",
      fieldHintText: "Дата",
    );

    birthDayController.text = formatter.format(birthDate.value);
  }

  void setData() {
    var user = FirebaseAuth.instance.currentUser!;

    user.updatePassword(passwordController.text);

    var data = {
      "email": user.email,
      "birthDay": birthDate.value,
      "name": nameController.text.trim(),
      "role": role.value.trim(),
    };

    FirebaseFirestore.instance.collection("users").doc(user.uid).set(data).then(
          (value) => Get.offAll(
            () => const HomeView(),
          ),
        );
  }
}
