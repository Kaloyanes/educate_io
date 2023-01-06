import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/components/teacher_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/liked_teachers_controller.dart';

class LikedTeachersView extends GetView<LikedTeachersController> {
  const LikedTeachersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Запазени учители'),
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

          var data = snapshot.data!.data()!["likedTeachers"] as List;

          if (data.isEmpty) {
            return Center(
              child: Text(
                "Нямаш запазени учители",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 280, mainAxisSpacing: 15),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var teacherData = FirebaseFirestore.instance
                  .collection("users")
                  .doc(data[index]);

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(data[index])
                    .get(),
                builder: (context, snapshot) {
                  var teacherData = snapshot.data;
                  if (teacherData == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var mapData = teacherData.data() ?? {};
                  mapData.addAll({"uid": data[index]});
                  return Obx(
                    () => HeroMode(
                      enabled: controller.heroTransition.value,
                      child: TeacherCard(
                        teacher: Teacher.fromMap(mapData),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
