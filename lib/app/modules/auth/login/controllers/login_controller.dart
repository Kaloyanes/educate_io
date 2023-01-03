import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/auth/login/components/forgot_password_dialog.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  final sizeStyle = const ButtonStyle(
    minimumSize: MaterialStatePropertyAll(
      Size(double.infinity, 40),
    ),
  );

  GlobalKey<FormState> formkey = GlobalKey();

  final showPassword = false.obs;
  set setPasswordVisibility(val) => showPassword.value = val;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginWithCredentials() async {
    Get.dialog(const Center(
      child: CircularProgressIndicator(),
    ));

    try {
      await FirebaseAuthService.login(emailController.text.removeAllWhitespace,
          passwordController.text.removeAllWhitespace);
    } catch (e) {
      Get.back();
      Get.dialog(
        AlertDialog(
          icon: const Icon(Icons.warning),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Ok"),
            ),
          ],
        ),
      );

      rethrow;
    }

    Get.offAllNamed(Routes.HOME)!;
    Future.delayed(
      const Duration(milliseconds: 600),
      () => ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Влязохте"),
        ),
      ),
    );
  }

  Future<void> forgotPassword() async {
    var forEmailController = TextEditingController(text: emailController.text);
    GlobalKey<FormState> forgotPasswordKey = GlobalKey();

    showDialog(
      context: Get.context!,
      builder: (context) => ForgotPasswordDialog(
          forgotPasswordKey: forgotPasswordKey,
          forEmailController: forEmailController),
    );
  }
}
