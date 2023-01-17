import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => RegisterController(),
    );
    initializeDateFormatting();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            stretch: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text("Регистрация"),
              expandedTitleScale: 1.5,
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    controller.registerForm(false),
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
                    SizedBox(
                      height: Get.mediaQuery.padding.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form registerForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          // Name
          controller.nameField(),
          const SizedBox(
            height: 15,
          ),
          // Email
          controller.emailField(),
          const SizedBox(
            height: 15,
          ),
          // Password
          controller.passwordField(),
          const SizedBox(
            height: 15,
          ),
          // Password verification
          controller.confirmPasswordField(),
          const SizedBox(
            height: 15,
          ),

          // Role selection
          // Рождена дата
          controller.birthDayField(),
          const SizedBox(
            height: 15,
          ),
          controller.phoneField(),
          const SizedBox(
            height: 15,
          ),
          controller.roleSelectionField(),
          const SizedBox(
            height: 15,
          ),
          Obx(() {
            if (controller.role.value == "teacher") {
              return controller.teacherSettings();
            }

            if (controller.role.value == "student") {
              return controller.studentSettings();
            }

            return Container();
          }),
        ],
      ),
    );
  }
}
