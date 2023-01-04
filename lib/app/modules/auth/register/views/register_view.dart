import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => RegisterController(),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Регистрация",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      // Name
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: controller.nameController,
                        decoration: const InputDecoration(
                          // border: OutlineInputBorder(),
                          label: Text("Име"),
                          prefixIcon: Icon(Icons.person),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Попълнете полето";
                          }

                          if (value.split(" ").length <= 1) {
                            return "Недопълнено име";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Email
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        controller: controller.emailController,
                        decoration: const InputDecoration(
                          // border: OutlineInputBorder(),
                          label: Text("Имейл"),
                          prefixIcon: Icon(Icons.email),
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
                      const SizedBox(
                        height: 15,
                      ),
                      // Password
                      Obx(
                        () => TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          controller: controller.passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Попълнете полето";
                            }

                            if (value.length < 8) {
                              return "Паролата трябва да бъде поне 8 букви";
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            label: const Text("Парола"),
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  controller.setPasswordVisibility =
                                      !controller.showPassword.value,
                              icon: const Icon(Icons.remove_red_eye),
                            ),
                          ),
                          obscureText: !controller.showPassword.value,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Password verification
                      Obx(
                        () => TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          controller: controller.confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Попълнете полето";
                            }

                            if (value != controller.passwordController.text) {
                              return "Паролите не са еднакви";
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            label: const Text("Потвърди парола"),
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  controller.setPasswordVisibility =
                                      !controller.showPassword.value,
                              icon: const Icon(Icons.remove_red_eye),
                            ),
                          ),
                          obscureText: !controller.showPassword.value,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      // Role selection
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          label: Text("Роля"),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Попълнете полето";
                          }

                          return null;
                        },
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: "student",
                            child: Text("Ученик"),
                          ),
                          DropdownMenuItem(
                            value: "teacher",
                            child: Text("Учител"),
                          ),
                          DropdownMenuItem(
                            value: "parent",
                            child: Text("Родител"),
                          ),
                        ],
                        onChanged: (value) => controller.setRole = value,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Рождена дата
                      TextFormField(
                        controller: controller.birthDayController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.cake),
                          label: Text("Рождена дата"),
                        ),
                        onTap: () => controller.changeDate(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Изберете дата";
                          }
                        },
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                  style: controller.sizeStyle,
                  onPressed: () => controller.createAccount(),
                  icon: const Icon(Icons.app_registration_rounded),
                  label: const Text("Регистриране"),
                ),
                const SizedBox(height: 15),
                TextButton.icon(
                  icon: SvgPicture.asset(
                    "assets/images/google_logo.svg",
                    width: 30,
                    height: 30,
                  ),
                  label: const Text("Google"),
                  onPressed: () => FirebaseAuthService.logInGoogle(),
                  style: controller.sizeStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
