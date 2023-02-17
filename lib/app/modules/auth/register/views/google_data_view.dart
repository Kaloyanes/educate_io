import 'package:educate_io/app/modules/auth/register/controllers/register_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

class GoogleDataView extends GetView<RegisterController> {
  const GoogleDataView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RegisterController());
    initializeDateFormatting();

    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              automaticallyImplyLeading: false,
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
                      controller.registerForm(true),
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
      ),
    );
  }
}
