import 'package:educate_io/app/modules/home/views/teach_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: const [
            DrawerHeader(
              child: Text("Maika"),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
                  ),
                ],
              ),
              Text(
                "Добре дошъл, ${"Калоян"}",
                style: Get.textTheme.headlineMedium,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Препоръчани учители",
                style: Get.textTheme.titleLarge,
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.teachers.length,
                  semanticChildCount: 2,
                  itemBuilder: (context, index) {
                    return TeachCard(teacher: controller.teachers[index]);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
