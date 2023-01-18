import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({
    super.key,
    required this.forgotPasswordKey,
    required this.forEmailController,
  });

  final GlobalKey<FormState> forgotPasswordKey;
  final TextEditingController forEmailController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      icon: const Icon(Icons.password),
      title: const Text("Сменете паролата"),
      content: Form(
        key: forgotPasswordKey,
        child: TextFormField(
          autofocus: true,
          controller: forEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            label: Text("Имейл"),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Попълнете полето";
            }

            if (!value.isEmail) {
              return "Невалиден имейл";
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Отказ"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (forgotPasswordKey.currentState?.validate() != true) {
              return;
            }

            await FirebaseAuthService.forgotPassword(forEmailController.text);

            ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
              content: Text("Проверете си пощата"),
              duration: Duration(seconds: 5),
            ));
            Get.back();
          },
          child: const Text("Смени паролата"),
        )
      ],
    );
  }
}
