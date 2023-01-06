import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/user_model.dart';
import 'package:educate_io/app/modules/home/views/home_view.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final subjectController = TextEditingController();
  final phoneNumController = TextEditingController();
  final subjects = <String>[].obs;
  set addSubject(String val) {
    subjects.add(val.capitalizeFirst!);
  }

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
    var data = <String, dynamic>{
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "role": role.value,
      "birthDay": birthDate.value,
      "subjects": subjects,
    };

    if (role.value.trim() == "teacher") {
      data.addAll({
        "phone": "+359${phoneNumController.text}",
        "subjects": subjects,
      });
    }

    try {
      FirebaseAuthService.createAccount(
        data,
        emailController.text,
        passwordController.text,
      );
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

  Future<void> googleRegister() async {
    if (!formKey.currentState!.validate()) return;

    var user = FirebaseAuth.instance.currentUser!;

    user.updatePassword(passwordController.text);

    var data = {
      "email": user.email,
      "birthDay": birthDate.value,
      "name": nameController.text.trim(),
      "role": role.value.trim(),
    };

    if (role.value.trim() == "teacher") {
      data.addAll({
        "phone": "+359${phoneNumController.text}",
        "subjects": subjects,
      });
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set(data);

    Get.offAllNamed(
      Routes.HOME,
    );
  }

  // Fields
  TextFormField birthDayField() {
    return TextFormField(
      controller: birthDayController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.cake),
        label: Text("Рождена дата"),
      ),
      onTap: () => changeDate(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Изберете дата";
        }

        if (role.value == "teacher" &&
            (DateTime.now().subtract(
                  DateTime.now().difference(
                    birthDate.value,
                  ),
                )).year <
                18) {
          return "Няма завършени 18 години";
        }
      },
      readOnly: true,
    );
  }

  Obx teacherSettings() {
    return Obx(() {
      if (role.value == "teacher") {
        return Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: phoneNumController,
              decoration: const InputDecoration(
                prefix: Text("+359"),
                label: Text("Телефонен номер"),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Добавете телефонен номер";
                }

                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(
                  9,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
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
          ],
        );
      }

      return Container();
    });
  }

  TextFormField emailField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
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
    );
  }

  TextFormField nameField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      controller: nameController,
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
    );
  }

  DropdownButtonFormField<String> roleSelectionField() {
    return DropdownButtonFormField(
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
      onChanged: (value) => setRole = value,
    );
  }

  Obx confirmPasswordField() {
    return Obx(
      () => TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        controller: confirmPasswordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Попълнете полето";
          }

          if (value != passwordController.text) {
            return "Паролите не са еднакви";
          }

          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: const Text("Потвърди парола"),
          prefixIcon: const Icon(Icons.password),
          suffixIcon: IconButton(
            onPressed: () => setPasswordVisibility = !showPassword.value,
            icon: const Icon(Icons.remove_red_eye),
          ),
        ),
        obscureText: !showPassword.value,
      ),
    );
  }

  Obx passwordField() {
    return Obx(
      () => TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        controller: passwordController,
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
            onPressed: () => setPasswordVisibility = !showPassword.value,
            icon: const Icon(Icons.remove_red_eye),
          ),
        ),
        obscureText: !showPassword.value,
      ),
    );
  }
}
