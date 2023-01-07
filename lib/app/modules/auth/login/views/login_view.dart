import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginController());

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Влизане",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    // key: controller.formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
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
                          height: 20,
                        ),
                        Obx(
                          () => TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: controller.passwordController,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => controller.forgotPassword(),
                            child: const Text("Забравил си паролата?"),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => controller.loginWithCredentials(),
                          icon: const Icon(Icons.login),
                          label: const Text("Влез"),
                          style: controller.sizeStyle,
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => Get.toNamed(Routes.REGISTER),
                    icon: const Icon(Icons.app_registration),
                    label: const Text("Направи си акаунт"),
                    style: controller.sizeStyle,
                  ),
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
      ),
    );
  }
}
