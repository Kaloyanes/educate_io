import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/components/teacher_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/liked_teachers_controller.dart';

class LikedTeachersView extends GetView<LikedTeachersController> {
  const LikedTeachersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Запазени ментори'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var data = List.castFrom<dynamic, String>(
              snapshot.data!.data()!["likedTeachers"] as List);

          controller.teachers = data;

          if (data.isEmpty) {
            return Center(
              child: Text(
                "Нямаш запазени ментори",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
          return GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              mainAxisExtent: 300,
              mainAxisSpacing: 15,
            ),
            children: [
              for (var index = 0; index < data.length; index++)
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .doc(data[index])
                      .get(),
                  builder: (context, snapshot) {
                    var teacherData = snapshot.data;
                    if (teacherData == null ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var mapData = teacherData.data() ?? {};

                    if (mapData.isEmpty) {
                      controller.removeTeacher(snapshot.data!.id);
                      return Container();
                    }
                    mapData.addAll({"uid": data[index]});

                    return TeacherCard(
                      subject: mapData["subjects"][0],
                      teacher: Teacher.fromMap(mapData),
                    );
                  },
                ),
            ].animate(interval: 100.ms).scaleXY(
                  begin: 0,
                  end: 1,
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: 500.ms,
                ),
          );
        },
      ),
    );
  }
}
