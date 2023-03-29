import 'package:educate_io/app/modules/home/components/teacher_card.dart';
import 'package:educate_io/app/modules/search/controllers/search_teachers_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';

class SearchView extends GetView<SearchTeachersController> {
  const SearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SearchTeachersController());
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 50),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
            child: TextField(
              magnifierConfiguration: const TextMagnifierConfiguration(),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                hintText: "Калоян Стоянов",
                label: Text("Търсене"),
                prefixIcon: Icon(
                  Icons.search,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              textInputAction: TextInputAction.search,
              onChanged: (value) => controller
                  .filterResults(value.trim().capitalize ?? value.trim()),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.filter(),
            icon: const Icon(Icons.filter_list),
          )
        ],
      ),
      body: CupertinoScrollbar(
        child: Obx(
          () => GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: controller.gridTeacherCount.value,
              mainAxisExtent: 300,
            ),
            children: [
              for (var i = 0;
                  i <
                      (controller.teachers.length < 10
                          ? controller.teachers.length
                          : 10);
                  i++)
                TeacherCard(
                  teacher: controller.teachers[i],
                  subject: controller.teachers[i].subjects[0],
                ),
            ].animate(interval: 100.ms).scaleXY(
                  begin: 0,
                  end: 1,
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: 500.ms,
                ),
            // itemBuilder: (context, index) => TeacherCard(
            //   teacher: controller.teachers[index],
            //   subject: controller.teachers[index].subjects[0],
            // ),
          ),
        ),
      ),
    );
  }
}
