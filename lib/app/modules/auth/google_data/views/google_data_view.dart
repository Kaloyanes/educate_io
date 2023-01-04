import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/google_data_controller.dart';

class GoogleDataView extends GetView<GoogleDataController> {
  const GoogleDataView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => GoogleDataController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Данни",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
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
                      TextFormField(
                        controller: controller.birthDayController,
                        decoration: const InputDecoration(
                          label: Text("Рождена дата"),
                          prefixIcon: Icon(Icons.cake),
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
                ElevatedButton(
                  onPressed: () => controller.setData(),
                  child: const Text("Направи акаунт"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
