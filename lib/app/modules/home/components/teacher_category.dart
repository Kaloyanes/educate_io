import 'package:educate_io/app/modules/home/components/teacher_card.dart';
import 'package:educate_io/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class teacher_category extends StatelessWidget {
  const teacher_category({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              "Програмист",
              style: Get.textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: controller.teachers.length,
            itemBuilder: (BuildContext context, int index) => TeacherCard(
              teacher: controller.teachers[index],
            ),
          ),
        ),
      ],
    );
  }
}
