import 'package:educate_io/app/modules/auth/register/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class GoogleDataView extends GetView<RegisterController> {
  const GoogleDataView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RegisterController());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            stretch: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text("Данни"),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    GoogleForm(),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () => controller.googleRegister(),
                      child: const Text("Направи акаунт"),
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

  Form GoogleForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          controller.nameField(),
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
          controller.roleSelectionField(),
          const SizedBox(
            height: 15,
          ),
          // Рождена дата
          controller.birthDayField(),

          // Teacher categories
          controller.teacherSettings(),
        ],
      ),
    );
  }
}
