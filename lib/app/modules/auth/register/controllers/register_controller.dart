import 'package:educate_io/app/models/user_model.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController

  final sizeStyle = ButtonStyle(
    elevation: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.pressed)) {
          return 5;
        }

        return 1;
      },
    ),
    minimumSize: const MaterialStatePropertyAll(
      Size(double.infinity, 50),
    ),
    textStyle: const MaterialStatePropertyAll(
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  final formatter = DateFormat.yMd("bg");

  final formKey = GlobalKey<FormState>();

  final showPassword = false.obs;
  set setPasswordVisibility(val) => showPassword.value = val;

  final birthDate = DateTime.now().obs;
  set setBirthDate(date) => birthDate.value = date;

  final role = "".obs;
  set setRole(val) => role.value = val;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
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

  void createAccount() {
    if (!formKey.currentState!.validate()) return;

    print("validated");

    var user = UserModel(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      role.value,
      birthDate.value,
    );

    try {
      FirebaseAuthService.createAccount(user);
    } on FirebaseException catch (e) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          title: Text(e.message!),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Ок"),
            ),
          ],
        ),
      );
    } finally {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Вече можете да си влезете в акаунта"),
        ),
      );
      Get.offAllNamed(Routes.HOME);
    }
  }
}
