import 'package:educate_io/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

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
                  autovalidateMode: AutovalidateMode.always,
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("Парола"),
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.remove_red_eye),
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => controller.loginWithCredentials(),
                        icon: Icon(Icons.login),
                        label: Text("Влез"),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.toNamed(Routes.REGISTER);
                  },
                  icon: Icon(Icons.app_registration),
                  label: Text("Направи си акаунт"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
