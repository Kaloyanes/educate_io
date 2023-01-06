import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/components/teacher_card.dart';
import 'package:educate_io/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherSubject extends StatefulWidget {
  const TeacherSubject({
    super.key,
    required this.subject,
  });

  final String subject;

  @override
  State<TeacherSubject> createState() => _TeacherSubjectState();
}

class _TeacherSubjectState extends State<TeacherSubject> {
  Future<List<Teacher>> getTeachers() async {
    print(widget.subject);

    var teachers = <Teacher>[];

    var teachersQuery = await FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: "teacher")
        .where("subjects", arrayContains: widget.subject)
        .get();

    (teachersQuery);
    (teachersQuery.docs[0].data());

    teachersQuery.docs.forEach((element) {
      print("getting elements");
      var teacher = Teacher.fromMap(element.data());
      (element.data());
      (element);
      (teacher);
      teachers.add(teacher);
    });
    (teachers);
    return teachers;
  }

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
        FutureBuilder(
          future: getTeachers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            var list = snapshot.data;
            (list);
            if (list == null) {
              return Text("null");
            }

            return SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) => TeacherCard(
                  teacher: list[index],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
