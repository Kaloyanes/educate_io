import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
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
          icon: Icon(Icons.warning),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Ok"),
            ),
          ],
        ),
      );

      rethrow;
    }

    Get.offAllNamed(Routes.HOME)!;
    Future.delayed(
      Duration(milliseconds: 600),
      () => ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("Влязохте"),
        ),
      ),
    );
  }
}
