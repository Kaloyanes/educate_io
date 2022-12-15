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
      drawer: NavigationDrawer(
        onDestinationSelected: (value) {},
        selectedIndex: 0,
        children: [
          SizedBox(
            height: Get.mediaQuery.padding.top,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Text(
              "EducateIO",
              style: Get.textTheme.titleLarge,
            ),
          ),
          SizedBox(
            height: Get.mediaQuery.padding.top,
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.home),
            label: Text("Home"),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.home),
            label: Text("Home"),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.home),
            label: Text("Home"),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(
              "Добре дошъл, ${"Калоян"}",
              style: Get.textTheme.headlineSmall,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Препоръчани учители",
                    style: Get.textTheme.titleLarge,
                  ),
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
          )
        ],
      ),
    );
  }
}
