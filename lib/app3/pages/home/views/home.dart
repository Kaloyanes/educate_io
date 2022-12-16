import 'package:educate_io/app/pages/home/components/teach_card.dart';
import 'package:educate_io/app/pages/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            snap: true,
            title: Text("EducateIO"),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30, left: 10, top: 20),
                    child: Text(
                      "Добре дошъл, Калоян",
                      style: Get.textTheme.titleLarge,
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.teachers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TeachCard(teacher: controller.teachers[index]);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                for (int i = 0; i < 100; i++) Text(i.toString())
              ],
            ),
          )
        ],
      ),
    );
  }
}
